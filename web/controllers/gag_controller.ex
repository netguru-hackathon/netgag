defmodule Netgag.GagController do
  use Netgag.Web, :controller
  alias Netgag.Gag

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    redirect(conn, to: gag_path(conn, :index))
  end

  def show(conn, %{"id" => slug}) do
    gag = Repo.get_by(Gag, slug: slug)
    render conn, "show.html", gag: gag
  end
end
