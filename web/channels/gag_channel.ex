defmodule Netgag.GagChannel do
  use Netgag.Web, :channel
  alias Netgag.Gag
  alias Netgag.Repo
  alias Netgag.CommentView

  def join("gag:" <> slug, _params, socket) do
    gag = get_gag_by_slug(slug)
    comments = Repo.all(
      from a in assoc(gag, :comments),
        order_by: [desc: a.id],
        limit: 200
    )
    resp = %{comments: Phoenix.View.render_many(comments, CommentView, "comment.json")}
    {:ok, resp, assign(socket, :slug, slug)}
  end

  def handle_in("new_comment", params, socket) do
    gag = get_gag_by_slug(socket.assigns.slug)
    changeset =
      gag
      |> build_assoc(:comments)
      |> Netgag.Comment.changeset(params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast! socket, "new_comment", %{
          id: comment.id,
          user: comment.user,
          body: comment.body,
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def get_gag_by_slug(slug) do
    Repo.get_by(Gag, slug: slug)
  end
end
