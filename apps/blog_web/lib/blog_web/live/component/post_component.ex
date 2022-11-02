defmodule BlogWeb.PostComponent do
  use BlogWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <h1>Title: <%= @title %></h1>
        <hr>
        <h2><%= @description %></h2>
        <hr>
        <%= for comment <- @comments do %>
          <ul>
            <.live_component
              module={BlogWeb.CommentComponent}
              id={comment.id}
              description={comment.description}/>
          </ul>
        <% end %>
        <div>
          <%= live_patch "back", to: @return_to, class: "button" %>
        </div>
      </div>
    """
  end
end
