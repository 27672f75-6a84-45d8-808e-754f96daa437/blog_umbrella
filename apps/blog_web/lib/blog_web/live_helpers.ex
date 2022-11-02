defmodule BlogWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def live_modal(assigns) do
    ~H"""
    <div class="phx-modal"
         phx-window-keydown="close"
         phx-key="escape"
         phx-capture-click="close"
         phx-target={@myself}>
      <div class="phx-modal-content">
        <%= live_patch "✖",
              to: @return_to,
              class: "phx-modal-close" %>
        <.live_component module={@component} id="modal" opts={@opts} />
      </div>
    </div>
  """
  end
end
