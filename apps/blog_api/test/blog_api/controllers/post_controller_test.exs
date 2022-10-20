defmodule BlogApi.Controllers.PostControllerTest do
  use BlogApi.ConnCase, async: true

  alias BlogDomain.Boards.Post
  alias BlogDomain.Accounts.User
  alias BlogDomain.Boards

  @valid_params %{
    user_name: "User",
    user_email: "User Email",
    password: "supersecret"
  }

  @valid_attrs %{title: "title", description: "description"}

  test "GET /posts", %{conn: conn} do
    owner = user_fixture(@valid_params)

    Enum.each(1..5, fn num ->
      post_fixture(owner, %{
        title: @valid_attrs.title <> "#{num}",
        description: @valid_attrs.description <> "#{num}"
      })
    end)

    conn = get(conn, Routes.post_path(conn, :index))

    assert %{
             "data" => [
               %{"description" => "description1", "title" => "title1"},
               %{"description" => "description2", "title" => "title2"},
               %{"description" => "description3", "title" => "title3"},
               %{"description" => "description4", "title" => "title4"},
               %{"description" => "description5", "title" => "title5"}
             ]
           } == json_response(conn, 200)
  end

  test "GET /posts/:id", %{conn: conn} do
    owner = user_fixture(@valid_params)
    %Post{id: id} = post_fixture(owner)

    conn = get(conn, Routes.post_path(conn, :show, id))

    assert %{"data" => %{"description" => "description", "title" => "title"}} =
             json_response(conn, 200)
  end

  test "POST /posts/", %{conn: conn} do
    %User{id: user_id} = user_fixture(@valid_params)

    conn =
      post(conn, Routes.post_path(conn, :create), %{
        "user" => %{"id" => user_id},
        "post" => @valid_attrs
      })

    assert %{"data" => %{"description" => "description", "title" => "title"}} =
             json_response(conn, 201)
  end

  test "UPDATE /posts/:id", %{conn: conn} do
    owner = user_fixture(@valid_params)
    %Post{id: id} = post_fixture(owner)

    conn =
      put(
        conn,
        Routes.post_path(conn, :update, id, %{
          "post" => %{description: "new desc", title: "new title"}
        })
      )

    assert %{"data" => %{"description" => "new desc", "title" => "new title"}} ==
             json_response(conn, 200)
  end

  test "DELETE /posts/:id", %{conn: conn} do
    owner = user_fixture(@valid_params)
    %Post{id: id} = post_fixture(owner)

    delete(conn, Routes.post_path(conn, :delete, id))

    assert [] = Boards.post_list()
  end
end
