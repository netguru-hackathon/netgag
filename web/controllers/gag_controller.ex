defmodule Netgag.GagController do
  use Netgag.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    redirect(conn, to: gag_path(conn, :index))
  end

  # def show(conn, %{"slug" => slug}) do
  #   Repo.get_by(Netgag.Gag, slug: slug)
  # end
end
