defmodule Netgag.GagChannel do
  use Netgag.Web, :channel
  alias Netgag.Gag
  alias Netgag.Repo

  def join("gag:" <> slug, _params, socket) do
    {:ok, assign(socket, :slug, slug)}
  end

  def handle_in("new_comment", params, socket) do
    gag = Repo.get_by(Gag, slug: socket.assigns.slug)
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
end
