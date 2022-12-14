defmodule BlogWeb.CommentWriteComponent do
  use BlogWeb, :live_component

  alias BlogDomain.Accounts.User
  alias BlogDomain.Boards

  @impl true
  def mount(socket) do
    {:ok, assign(socket, %{comment_changeset: Boards.change_comment()})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form let={f} for={@comment_changeset}
             phx-change="validate_check"
             phx-submit="write"
             phx-target={@myself}>

          <%= label f, :description %>
          <%= text_input f, :description %>
          <%= error_tag f, :description %>

          <%= submit "Write" %>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("validate_check", %{"comment" => comment_params}, socket) do
    {:noreply, assign(socket, %{comment_changeset: Boards.change_comment(comment_params)})}
  end

  def handle_event("write", %{"comment" => comment_params}, socket) do
    case Boards.write_comment(
           %User{id: socket.assigns.user_id},
           socket.assigns.post_id,
           comment_params
         ) do
      {:ok, _comment} ->
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, assign(socket, %{comment_changeset: Boards.change_comment()})}
    end
  end
end
