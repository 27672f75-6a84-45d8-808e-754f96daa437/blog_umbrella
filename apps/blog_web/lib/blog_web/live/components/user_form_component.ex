defmodule BlogWeb.UserFormComponent do
  use BlogWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@changeset}
            phx-change="validate_check"
            phx-submit={@live_action} >
        <%= label f, :user_email %>
        <%= email_input f, :user_email, required: true %>
        <%= error_tag f, :user_email %>

        <%= if @live_action == :register do %>
          <%= label f, :user_name %>
          <%= text_input f, :user_name, required: true %>
          <%= error_tag f, :user_name %>
        <% end %>

        <%= label f, :password %>
        <%= password_input f, :password, required: true%>
        <%= error_tag f, :password %>

        <%= submit @live_action %>
        </.form>
      </div>
    """
  end
end
