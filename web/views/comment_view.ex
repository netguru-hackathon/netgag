defmodule Netgag.CommentView do
  use Netgag.Web, :view

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      user: comment.user
    }
  end
end
