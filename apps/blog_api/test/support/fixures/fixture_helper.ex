defmodule BlogApi.FixtureHelper do
  alias BlogDomain.{Accounts, Boards}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        user_email: "example@example.com#{System.unique_integer([:positive])}",
        user_name: "username",
        password: attrs[:password] || "supersecret"
      })
      |> Accounts.create_user()

    user
  end

  def post_fixture(owner, attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "title",
        description: "description"
      })
      |> then(fn params ->
        Boards.create_post(owner, params)
      end)

    post
  end

  def comment_fixture(onwer, owner_post_id, attrs \\ {}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        description: "desc"
      })
      |> then(fn params ->
        Boards.write_comment(onwer, owner_post_id, params)
      end)

    comment
  end
end
