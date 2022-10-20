defmodule BlogApi.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import BlogApi.ConnCase
      import BlogApi.FixtureHelper

      alias BlogApi.Router.Helpers, as: Routes

      @endpoint BlogApi.Endpoint
    end
  end

  setup tags do
    BlogDomain.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
