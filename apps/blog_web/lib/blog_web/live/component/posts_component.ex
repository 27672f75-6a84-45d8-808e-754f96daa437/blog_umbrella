defmodule BlogWeb.PostsComponent do
  use BlogWeb, :live_component

  def render(assigns) do
    ~H"""
      <table>
          <%= for post <- @posts do %>
            <tr>
              <td><%= post.title %></td>
              <td><%= live_patch "View", to: Routes.post_path(@socket, :index, post.id)%></td>

              <%= if @user_id == post.user_id do %>
                <td><%= live_patch( "Edit", to: Routes.post_path(@socket, :edit, post.id)) %> </td>
              <% end %>
            </tr>
          <% end %>
      </table>
    """
  end
end
