defmodule BlogApi.UserController do
  use BlogApi, :controller

  alias BlogDomain.Accounts
  alias BlogDomain.Accounts.User

  def index(conn, _params) do
    users = Accounts.user_list()
    render(conn, "index.json", %{users: users})
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.json", %{user: user})
  end

  def update(conn, %{"id" => id} = params) do
    {:ok, {:ok, %User{} = user}} = Accounts.update_user(%User{id: id}, params)

    conn
    |> render("show.json", %{user: user})
  end
end
