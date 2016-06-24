defmodule Netgag.GagChannel do
  use Netgag.Web, :channel
  alias Netgag.Gag

  def join("gag:" <> slug, _params, socket) do
    {:ok, assign(socket, :slug, slug)}
  end

  def handle_in("new_comment", params, socket) do
    gag = Repo.get_by(Gag, slug: socket.assigns.slug)
    broadcast! socket, "new_comment", %{gag: gag.slug}
  end
end
