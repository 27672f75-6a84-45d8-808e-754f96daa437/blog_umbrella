defmodule BlogWeb.PostLive.FormComponent do
  use BlogWeb, :live_component

  alias BlogDomain.Boards
  alias BlogDomain.Boards.Post
  alias BlogDomain.Accounts.User

  def update(%{post: post} = assigns, socket) do
    changeset = Boards.change_post(post)
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  @spec handle_event(<<_::32, _::_*80>>, map, any) :: {:noreply, any}
  def handle_event("validate_check", %{"post" => post_params}, socket) do
    {:noreply, assign(socket, %{post: Boards.change_post(%Post{}, post_params)})}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    post_id = socket.assigns.id
    case Boards.update_post(post_id, post_params) do
      {:ok, _post} ->
        {:noreply,
          socket
          |> put_flash(:info, "Successful Post Edit !")
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
    end
  end


  defp save_post(socket, :new, post_params) do
    case Boards.create_post(%User{id: socket.assigns.user_id}, post_params) do
      {:ok, _post} ->
        {:noreply,
          socket
          |> put_flash(:info, "Successful Post Write !")
          |> push_redirect(to: socket.assigns.return_to)
        }

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
