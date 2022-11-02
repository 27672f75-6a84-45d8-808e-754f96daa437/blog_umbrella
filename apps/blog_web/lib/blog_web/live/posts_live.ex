defmodule BlogWeb.PostsLive do
  use BlogWeb, :live_view

  alias BlogDomain.Boards

  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, assign(socket, %{posts: Boards.post_list()})}
    else
      {:ok, assign(socket, %{posts: Boards.post_list()})}
    end
  end

  def handle_params(%{"id" => id}, _url, socket) do
    post = Boards.get_post(id)

    {:noreply,
     assign(socket, %{
       post: post,
       comments: Boards.list_post_comments(id),
       page_title: post.title
     })}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, %{post: nil})}
  end
end
