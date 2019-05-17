defmodule CheckersWeb.GameChannel do
  use CheckersWeb, :channel
  alias CheckersWeb.Presence
  alias Checkers.Search

  @rooms 1..1000

  def join("game:lobby", _payload, socket) do
    Presence.track(socket, :online, %{})
    {:ok, socket}
  end

  def join(_lobby, _payload, socket) do
    Presence.track(socket, :in_game, %{})
    {:ok, socket}
  end

  def handle_in("find", _payload, socket) do
    case GenServer.call(Search, :game_queue) do
      {:ok, queue} ->
        oponent = Enum.random(queue)
        create_game_lobby(oponent, socket)
        GenServer.cast(Search, {:remove, oponent})
      {:empty, _} ->
        GenServer.cast(Search, {:reserve, socket})
        Presence.track(socket, :find, %{})
    end
    {:reply, :ok, socket}
  end

  def handle_in("stop_find", _payload, socket) do
    Presence.untrack(socket, :find)
    {:reply, :ok, socket}
  end

  # > Check on existing game lobby
  def create_game_lobby(oponent, socket) do
    room_number = Enum.random(@rooms)
    query = "match_ready"
    push(socket, query, %{lobby_individual_number: room_number})
    push(oponent, query, %{lobby_individual_number: room_number})
  end
end
