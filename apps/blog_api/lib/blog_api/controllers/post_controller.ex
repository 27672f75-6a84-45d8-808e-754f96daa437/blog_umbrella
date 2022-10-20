defmodule BlogApi.PostController do
  use BlogApi, :controller

  alias BlogApi.Utils
  alias BlogDomain.Boards
  alias BlogDomain.Boards.Post
  alias BlogDomain.Accounts

  def index(conn, _params) do
    posts = Boards.post_list()
    render(conn, "index.json", %{posts: posts})
  end

  def show(conn, %{"id" => id}) do
    post = Boards.get_post(id)
    render(conn, "show.json", %{post: post})
  end

  def create(conn, %{"user" => %{"id" => id}, "post" => post_params}) do
    user = Accounts.get_user(id)

    case Boards.create_post(user, post_params) do
      {:ok, %Post{} = post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.post_path(conn, :show, post))
        |> render("show.json", %{post: post})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    case Boards.update_post(id, post_params) do
      {:ok, {:ok, %Post{} = post}} ->
        render(conn, "show.json", %{post: post})

      {:ok, {:error, :not_found}} ->
        conn
        |> put_status(:not_found)
        |> put_view(BlogApi.ErrorView)
        |> render(:"404")

      {:ok, {:error, %Ecto.Changeset{} = changeset}} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      {:error, _} ->
        conn |> render("errors.json", %{errors: Utils.internal_server_error()})
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Boards.get_post(id)

    case Boards.delete_post(post) do
      {:ok, %Post{}} -> send_resp(conn, :no_content, "")
      _ -> conn |> render("errors.json", %{errors: Utils.internal_server_error()})
    end
  end
end
