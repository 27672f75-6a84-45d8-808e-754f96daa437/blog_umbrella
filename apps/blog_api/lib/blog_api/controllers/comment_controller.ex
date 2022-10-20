defmodule BlogApi.CommentController do
  use BlogApi, :controller

  alias BlogApi.Utils
  alias BlogDomain.Boards
  alias BlogDomain.Boards.Comment
  alias BlogDomain.Accounts

  def index(conn, %{"post_id" => post_id}) do
    comments = Boards.list_post_comments(post_id)
    render(conn, "index.json", %{comments: comments})
  end

  def show(conn, %{"post_id" => post_id, "id" => id}) do
    comment = Boards.get_post_comment(post_id, id)
    render(conn, "show.json", %{comment: comment})
  end

  def create(conn, %{"user" => %{"id" => id}, "post_id" => post_id, "comment" => comment_param}) do
    user = Accounts.get_user(id)
    {post_id, _} = Integer.parse(post_id)

    case Boards.write_comment(user, post_id, comment_param) do
      {:ok, %Comment{} = comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.post_path(conn, :show, comment))
        |> render("show.json", %{comment: comment})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})
    end
  end

  def update(conn, %{
        "user" => %{"id" => id},
        "post_id" => post_id,
        "id" => comment_id,
        "comment" => comment
      }) do
    user = Accounts.get_user(id)

    case Boards.update_post_comment(user, post_id, comment_id, comment) do
      {:ok, {:ok, %Comment{} = comment}} ->
        render(conn, "show.json", %{comment: comment})

      {:ok, {:error, %Ecto.Changeset{} = changeset}} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      {:ok, {:error, :not_found}} ->
        conn
        |> put_status(:not_found)
        |> put_view(BlogApi.ErrorView)
        |> render(:"404")

      {:error, _} ->
        conn |> render("errors.json", %{errors: Utils.internal_server_error()})
    end
  end

  def delete(conn, %{"post_id" => post_id, "id" => id}) do
    comment = Boards.get_post_comment(post_id, id)

    case Boards.delete_comment(comment) do
      {:ok, %Comment{}} -> send_resp(conn, :no_content, "")
      _ -> :error
    end
  end
end
