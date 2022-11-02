defmodule BlogWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  def log_in_user(conn, user_id) do
    conn
    |> renew_session()
    |> put_session(:user_id, user_id)
    |> redirect(to: "/")
  end

  def log_out_user(conn) do
    conn
    |> renew_session()
    |> redirect(to: "/")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def redirect_if_user_id_authenticated(conn, _opts) do
    if conn.assigns[:user_id] do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end
end
