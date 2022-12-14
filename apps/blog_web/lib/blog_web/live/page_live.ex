defmodule BlogWeb.PageLive do
  use BlogWeb, :live_view

  alias BlogDomain.Accounts
  alias BlogDomain.Accounts.User

  alias BlogDomain.Boards

  @impl true
  def mount(_params, _seission, socket) do
    if connected?(socket), do: Blog.PubSub.subscribe()

    socket =
      socket
      # 변수
      |> assign(%{
        user_id: nil,
        user_changeset: Accounts.change_user(),
        posts:
          Boards.post_list()
          |> Enum.sort(&(&1.id <= &2.id))
      })
      # 모달 제어
      |> assign(%{
        register_modal: false,
        login_modal: false,
        post_modal: false,
        post_write_modal: false,
        post_edit_modal: false,
        comment_write_modal: false,
        comment_edit_modal: false
      })

    {:ok, socket}
  end

  @impl true
  def handle_info({:post_created, {:ok, post}}, socket) do
    posts =
      [post | socket.assigns.posts]
      |> Enum.sort(&(&1.id <= &2.id))

    {:noreply, assign(socket, %{posts: posts, post_write_modal: false})}
  end

  def handle_info({:post_updated, {:ok, _post}}, socket) do
    {:noreply,
     assign(socket, %{
       posts:
         Boards.post_list()
         |> Enum.sort(&(&1.id <= &2.id)),
       post_edit_modal: false
     })}
  end

  def handle_info({:comment_created, {:ok, _comment}}, socket) do
    {:noreply, assign(socket, %{comment_write_modal: false})}
  end

  def handle_info({:comment_updated, {:ok, _comment}}, socket) do
    {:noreply, assign(socket, %{comment_edit_modal: false})}
  end

  def handle_info({_message, {:error, _changeset}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("register_validate_check", %{"user" => user_params}, socket) do
    {:noreply, assign(socket, %{user_changeset: Accounts.change_user(user_params)})}
  end

  def handle_event("login_validate_check", %{"user" => user_params}, socket) do
    {:noreply, assign(socket, %{user_changeset: Accounts.change_login_user(user_params)})}
  end

  def handle_event("register", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, %User{id: user_id}} ->
        {:noreply,
         socket
         |> assign(%{
           user_id: user_id,
           user_changeset: Accounts.change_user(),
           register_modal: false
         })}
    end
  end

  def handle_event(
        "login",
        %{"user" => %{"user_email" => user_email, "password" => password}},
        socket
      ) do
    case Accounts.authenticate_by_username_and_pass(user_email, password) do
      {:ok, %User{id: user_id}} ->
        {:noreply,
         socket
         |> assign(%{user_id: user_id, user_changeset: Accounts.change_user(), login_modal: false})}
    end
  end

  def handle_event("logout", _params, socket) do
    {:noreply, assign(socket, %{user_id: nil})}
  end

  def handle_event("post_view", %{"id" => post_id}, socket) do
    {:noreply, assign(socket, %{post: Boards.get_post_preload(post_id), post_modal: true})}
  end

  def handle_event("post_new", _params, socket) do
    {:noreply, assign(socket, %{post_write_modal: true})}
  end

  def handle_event("post_edit", %{"id" => post_id}, socket) do
    {:noreply, assign(socket, %{post_edit_modal: true, post_id: post_id})}
  end

  def handle_event("comment_new", %{"post_id" => post_id}, socket) do
    post_id = String.to_integer(post_id)

    {:noreply,
     assign(socket, %{
       comment_write_modal: true,
       post_modal: false,
       post_id: post_id
     })}
  end

  def handle_event("comment-edit", %{"id" => comment_id, "post-id" => post_id}, socket) do
    {:noreply,
     assign(socket, %{
       comment_edit_modal: true,
       post_modal: false,
       post_id: post_id,
       comment_id: comment_id
     })}
  end

  def handle_event("home", %{"id" => user_id}, socket) do
    assign_home_user_id(String.to_integer(user_id), socket)
  end

  def handle_event("home", %{}, socket) do
    assign_home_user_id(nil, socket)
  end

  def handle_event("open", %{"id" => "register-modal"}, socket) do
    {:noreply, assign(socket, %{register_modal: true})}
  end

  def handle_event("open", %{"id" => "login-modal"}, socket) do
    {:noreply, assign(socket, %{login_modal: true})}
  end

  def handle_event("close", %{"id" => "register-modal"}, socket) do
    {:noreply, assign(socket, %{register_modal: false, user_changeset: Accounts.change_user()})}
  end

  def handle_event("close", %{"id" => "login-modal"}, socket) do
    {:noreply, assign(socket, %{login_modal: false, user_changeset: Accounts.change_user()})}
  end

  def handle_event("close", %{"id" => "post-modal"}, socket) do
    {:noreply, assign(socket, %{post_modal: false})}
  end

  def handle_event("close", %{"id" => "post-write-modal"}, socket) do
    {:noreply, assign(socket, %{post_write_modal: false})}
  end

  def handle_event("close", %{"id" => "post-edit-modal"}, socket) do
    {:noreply, assign(socket, %{post_edit_modal: false})}
  end

  def handle_event("close", %{"id" => "comment-write-modal"}, socket) do
    {:noreply, assign(socket, %{comment_write_modal: false})}
  end

  def handle_event("close", %{"id" => "comment-edit-modal"}, socket) do
    {:noreply, assign(socket, %{comment_edit_modal: false})}
  end

  defp assign_home_user_id(user_id, socket) do
    {:noreply,
     assign(
       socket,
       %{
         user_id: user_id,
         register_modal: false,
         login_modal: false,
         post_modal: false,
         post_write_modal: false,
         post_edit_modal: false,
         comment_write_modal: false,
         comment_edit_modal: false
       }
     )}
  end
end
