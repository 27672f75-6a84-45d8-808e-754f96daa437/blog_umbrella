defmodule BlogWeb.LiveAuth do
  import Phoenix.LiveView

  def on_mount(:user, _params, session, socket) do
    case Map.fetch(session, "user_id") do
      {:ok, user_id} -> {:cont, assign_new(socket, :user_id, fn -> user_id end)}
      :error -> {:cont, assign_new(socket, :user_id, fn -> nil end)}
    end
  end
end
