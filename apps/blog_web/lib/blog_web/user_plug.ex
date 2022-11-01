defmodule BlogWeb.UserPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    assign(conn, :user_id, get_session(conn, :user_id) || nil)
  end
end
