defmodule Netgag.GagChannel do
  use Netgag.Web, :channel
  alias Netgag.Gag
  alias Netgag.Repo
  alias Netgag.CommentView
  require IEx

  def join("gag:" <> slug, _params, socket) do
    gag = get_gag_by_slug(slug)
    if gag.page == nil do
      response = fetch_memes
    else
      response = fetch_memes(gag.page)
    end
    memes = response["data"]
    current_meme = List.first(memes)
    if gag.meme == nil do
      current_meme = List.first(memes)
      changeset = Gag.changeset(gag, %{meme: current_meme["id"]})
      res = Repo.update(changeset)
    else
      current_meme = Enum.find(memes, fn(meme) -> meme["id"] == gag.meme end)
    end
    next_page = response["paging"]["next"]

    comments = Repo.all(
      from a in assoc(gag, :comments),
        order_by: [asc: a.id],
        limit: 200
    )
    resp = %{comments: Phoenix.View.render_many(comments, CommentView, "comment.json"), current_meme: current_meme}
    {:ok, resp, socket |> assign(:slug, slug) |> assign(:memes, memes) |> assign(:current_meme, current_meme) |> assign(:next_page, next_page)}
  end

  def fetch_memes(page \\ nil) do
    url = "http://infinigag.k3min.eu/hot/#{page}"
    http_response = HTTPoison.get! url
    {:ok, response} = Poison.decode http_response.body
    response
  end

  def handle_in("next_gag", params, socket) do
    gag = get_gag_by_slug(socket.assigns.slug)
    current_meme = socket.assigns.current_meme
    memes = socket.assigns.memes
    next_meme = get_next_meme(memes, current_meme)
    next_page = socket.assigns.next_page
    if !next_meme do
      response = fetch_memes(next_page)
      next_page = response["paging"]["next"]
      memes = response["data"]
      next_meme = List.first(memes)
    end
    changeset = Gag.changeset(gag, %{meme: next_meme["id"]})
    res = Repo.update(changeset)
    broadcast! socket, "new_gag", %{gag: next_meme}
    {:reply, :ok, socket |> assign(:current_meme, next_meme) |> assign(:memes, memes) |> assign(:next_page, next_page) }
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

  def get_next_meme(memes, current_meme) do
   get_next_meme(memes, current_meme, false)
  end

  def get_next_meme([meme | tail], current_meme, this_one) do
    if this_one do
      meme
    else
      if meme["id"] == current_meme["id"] do
        get_next_meme(tail, current_meme, true)
      else
        get_next_meme(tail, current_meme, false)
      end
    end
  end

  def get_next_meme([], _, _) do
    nil
  end
end
