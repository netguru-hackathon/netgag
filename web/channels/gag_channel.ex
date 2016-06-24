defmodule Netgag.GagChannel do
  use Netgag.Web, :channel

  def join("gag:" <> slug, _params, socket) do
    {:ok, assign(socket, :slug, slug)}
  end
end
