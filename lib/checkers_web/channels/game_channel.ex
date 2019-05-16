defmodule CheckersWeb.GameChannel do
  use CheckersWeb, :channel
  alias CheckersWeb.Presence

  def join("game:lobby", _payload, socket) do
    Presence.track(socket, :online, %{})
    {:ok, socket}
  end

  def handle_in("find", _payload, socket) do
    Presence.track(socket, :find, %{})
    {:reply, :ok, socket}
  end

  def handle_in("stop_find", _payload, socket) do
    Presence.untrack(socket, :find)
    {:reply, :ok, socket}
  end
end
