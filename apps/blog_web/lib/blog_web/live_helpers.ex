defmodule BlogWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS
  def live_modal(assigns) do
    ~H"""
    <div id="modal"
         class="phx-modal fade-in"
         phx-remove={hide_modal()}>
      <div id="modal-content"
           class="phx-modal-content fade-in-scale"
           phx-click-away={JS.dispatch("click", to: "#close")}
           phx-window-keydown={JS.dispatch("click", to: "#close")}
           phx-key="escape">
        <%= live_patch "✖",
              to: @return_to,
              class: "phx-modal-close",
              phx_click: hide_modal()%>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
  """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
