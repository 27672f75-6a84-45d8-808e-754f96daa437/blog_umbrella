defmodule BlogWeb.RegisterLive do
  use BlogWeb, :live_view

  alias BlogDomain.Accounts

  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, assign(socket, %{changeset: Accounts.change_user(), trigger_submit: false})}
    else
      {:ok, assign(socket, %{changeset: Accounts.change_user(), trigger_submit: false})}
    end
  end

  def handle_event("validate_check", %{"user" => user_params}, socket) do
    {:noreply, assign(socket, %{changeset: Accounts.change_user(user_params)})}
  end

  def handle_event("register", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user(user_params)
    IO.inspect(changeset)
    {:noreply, assign(socket, %{changeset: changeset, trigger_submit: changeset.valid?})}
  end
end
