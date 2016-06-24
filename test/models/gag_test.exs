defmodule Netgag.GagTest do
  use Netgag.ModelCase

  alias Netgag.Gag

  @valid_attrs %{meme: "some content", page: "some content", section: "some content", slug: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Gag.changeset(%Gag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Gag.changeset(%Gag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
