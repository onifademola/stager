defmodule Stager.CommentController do
  use StagerWeb, :controller

  alias Stager.Repo
  alias Stager.Teachers.Post

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    post = Repo.get(Post, post_id)
    comment_changeset = Ecto.build_assoc(post, :comments, body: comment_params["body"])
    Repo.insert(comment_changeset)

    conn
    |> put_flash(:info, "Comment created successfully.")
    # |> redirect(to: post_Path(conn, :show, post))
  end
end
