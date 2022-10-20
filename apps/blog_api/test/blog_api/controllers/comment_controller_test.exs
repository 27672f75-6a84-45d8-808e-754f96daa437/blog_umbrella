defmodule BlogApi.Controllers.CommentControllerTest do
  use BlogApi.ConnCase, async: true

  alias BlogDomain.Boards
  alias BlogDomain.Boards.{Post, Comment}
  alias BlogDomain.Accounts.User

  @valid_user_params %{
    user_name: "User",
    user_email: "User Email",
    password: "supersecret"
  }
  @valid_post_params %{title: "title", description: "description"}
  @valid_comment_params %{description: "desc"}

  test "GET /posts/:post_id/comments", %{conn: conn} do
    owner = user_fixture(@valid_user_params)
    %Post{id: id} = post_fixture(owner, @valid_post_params)

    Enum.each(1..5, fn num ->
      comment_fixture(owner, id, %{description: @valid_comment_params.description <> "#{num}"})
    end)

    conn = get(conn, Routes.comment_path(conn, :index, id))

    assert %{
             "data" => [
               %{"description" => "desc1"},
               %{"description" => "desc2"},
               %{"description" => "desc3"},
               %{"description" => "desc4"},
               %{"description" => "desc5"}
             ]
           } = json_response(conn, 200)
  end

  test "GET /posts/:post_id/comment/:id", %{conn: conn} do
    owner = user_fixture(@valid_user_params)
    %Post{id: post_id} = post_fixture(owner, @valid_post_params)
    %Comment{id: id} = comment_fixture(owner, post_id, @valid_comment_params)

    conn = get(conn, Routes.comment_path(conn, :show, post_id, id))

    assert %{"data" => %{"description" => "desc"}} = json_response(conn, 200)
  end

  test "POST /posts/:post_id/comment/", %{conn: conn} do
    %User{id: id} = owner = user_fixture(@valid_user_params)
    %Post{id: post_id} = post_fixture(owner, @valid_post_params)

    conn =
      post(
        conn,
        Routes.comment_path(conn, :create, post_id, %{
          "user" => %{"id" => id},
          "comment" => @valid_comment_params
        })
      )

    assert %{"data" => %{"description" => "desc"}} = json_response(conn, 201)
  end

  test "UPDATE /posts/:post_id/comments/:id", %{conn: conn} do
    %User{id: owner_id} = owner = user_fixture(@valid_user_params)
    %Post{id: post_id} = post_fixture(owner, @valid_post_params)
    %Comment{id: id} = comment_fixture(owner, post_id, @valid_comment_params)

    conn =
      put(
        conn,
        Routes.comment_path(conn, :update, post_id, id, %{
          "user" => %{"id" => owner_id},
          "comment" => %{"description" => "new desc"}
        })
      )

    assert %{"data" => %{"description" => "new desc"}} = json_response(conn, 200)
  end

  test "DELETE /posts/:post_id/comments/:id", %{conn: conn} do
    %User{} = owner = user_fixture(@valid_user_params)
    %Post{id: post_id} = post_fixture(owner, @valid_post_params)
    %Comment{id: id} = comment_fixture(owner, post_id, @valid_comment_params)

    delete(conn, Routes.comment_path(conn, :delete, post_id, id))

    assert [] = Boards.get_user_post_all_comments(owner, post_id)
  end
end
