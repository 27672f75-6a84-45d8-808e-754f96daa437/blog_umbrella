defmodule BlogWeb.PostFormComponent do
  use BlogWeb, :live_component

  alias BlogDomain.Boards

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset =  Boards.change_post(post)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end


end
