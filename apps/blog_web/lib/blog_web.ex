defmodule BlogWeb do
  def controller() do
    quote do
      use Phoenix.Controller, namespace: BlogWeb

      import Plug.Conn
      import BlogWeb.Gettext
      alias BlogWeb.Router.Helpers, as: Routes
    end
  end

  def view() do
    quote do
      use Phoenix.View,
        root: "lib/blog_web/templates",
        namespace: BlogWeb

      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())
    end
  end

  def live_view() do
    quote do
      use Phoenix.LiveView,
        layout: {BlogWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component() do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component() do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router() do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel() do
    quote do
      use Phoenix.Channel
      import BlogWeb.Gettext
    end
  end

  defp view_helpers() do
    quote do
      use Phoenix.HTML

      import Phoenix.LiveView.Helpers
      import BlogWeb.LiveHelpers

      import Phoenix.View

      import BlogWeb.ErrorHelpers
      import BlogWeb.Gettext
      alias BlogWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
