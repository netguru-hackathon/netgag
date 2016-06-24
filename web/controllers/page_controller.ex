defmodule Netgag.PageController do
  use Netgag.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
