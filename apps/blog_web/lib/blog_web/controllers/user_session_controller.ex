defmodule BlogWeb.UserSessionController do
  use BlogWeb, :controller

  alias BlogDomain.Accounts
  alias BlogDomain.Accounts.User
  alias BlogWeb.UserAuth

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, %User{id: user_id}} ->
        conn
        |> put_flash(:info, "Successful User Register!")
        |> UserAuth.log_in_user(user_id)
    end
  end

  def login(conn, %{"user" => %{"user_email" => user_email, "password" => password}}) do
    case Accounts.authenticate_by_username_and_pass(user_email, password) do
      {:ok, %User{id: user_id}} ->
        conn
        |> put_flash(:info, "Successful User Login!")
        |> UserAuth.log_in_user(user_id)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Suceessful User Logout!")
    |> UserAuth.log_out_user()
  end
end
