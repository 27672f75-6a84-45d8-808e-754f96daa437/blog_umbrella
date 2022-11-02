defmodule BlogWeb.PostLive.Index do
  use BlogWeb, :live_view

  alias BlogDomain.Boards
  alias BlogDomain.Boards.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, assign(socket, %{posts: Boards.post_list() })}
    else
      {:ok, assign(socket, %{posts: Boards.post_list() })}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"post_id" => id}) do
    socket
    |> assign(:post, Boards.get_post(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:post, nil)
  end
end
# <td><%= live_patch "View", to: Routes.post_index_path(@socket, :show, post)%></td>
