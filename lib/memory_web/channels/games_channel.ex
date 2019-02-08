defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Memory.newGame()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Memory.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("flipTile", %{"value" => value, "index" => index}, socket) do
    game = Memory.flipTile(socket.assigns[:game], value, index)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Memory.client_view(game)}}, socket}
  end

  def handle_in("reset", _, socket) do
    game = Memory.newGame()
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Memory.client_view(game)}}, socket}
  end

  def handle_in("checkMatch", %{}, socket) do
    game = Memory.checkMatch(socket.assigns[:game])
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => Memory.client_view(game)}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end