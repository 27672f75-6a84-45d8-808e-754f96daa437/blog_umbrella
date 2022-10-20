# BlogApi

## Router

```
    user_path     GET     /api/users                        BlogApi.UserController :index
    user_path     GET     /api/users/:id                    BlogApi.UserController :show
    user_path     PATCH   /api/users/:id                    BlogApi.UserController :update
                  PUT     /api/users/:id                    BlogApi.UserController :update
    user_path     POST    /api/register                     BlogApi.UserController :register
    post_path     GET     /api/posts                        BlogApi.PostController :index
    post_path     GET     /api/posts/:id                    BlogApi.PostController :show
    post_path     POST    /api/posts                        BlogApi.PostController :create
    post_path     PATCH   /api/posts/:id                    BlogApi.PostController :update
                  PUT     /api/posts/:id                    BlogApi.PostController :update
    post_path     DELETE  /api/posts/:id                    BlogApi.PostController :delete
    comment_path  GET     /api/posts/:post_id/comments      BlogApi.CommentController :index
    comment_path  GET     /api/posts/:post_id/comments/:id  BlogApi.CommentController :show
    comment_path  POST    /api/posts/:post_id/comments      BlogApi.CommentController :create
    comment_path  PATCH   /api/posts/:post_id/comments/:id  BlogApi.CommentController :update
                  PUT     /api/posts/:post_id/comments/:id  BlogApi.CommentController :update
    comment_path  DELETE  /api/posts/:post_id/comments/:id  BlogApi.CommentController :delete
```
