defmodule Netgag.GagChannel do
  use Netgag.Web, :channel
  alias Netgag.Gag
  alias Netgag.Repo
  alias Netgag.CommentView
  require IEx

  def join("gag:" <> slug, _params, socket) do
    gag = get_gag_by_slug(slug)

    http_response = HTTPoison.get! "http://infinigag.k3min.eu/"
    {:ok, response} = Poison.decode http_response.body
    next_page = response["paging"]["next"]
    memes = response["data"]
    current_meme = List.first(memes)
    # IEx.pry

    comments = Repo.all(
      from a in assoc(gag, :comments),
        order_by: [asc: a.id],
        limit: 200
    )
    resp = %{comments: Phoenix.View.render_many(comments, CommentView, "comment.json"), current_meme: current_meme}
    {:ok, resp, assign(socket, :slug, slug)}
    # socket = socket
    # |> assign(:slug, slug)
    # |> assign(:memes, memes)
    # |> assign(:current_meme, current_meme)
    # {:ok, resp, socket}
  end

  def handle_in("next_gag", params, socket) do
    http_response = HTTPoison.get! "http://infinigag.k3min.eu/"
    {:ok, response} = Poison.decode http_response.body
    next_page = response["paging"]["next"]
    memes = response["data"]
    next_meme = List.last(memes)
    broadcast! socket, "new_gag", %{gag: next_meme}
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

  def get_active_meme()
end
