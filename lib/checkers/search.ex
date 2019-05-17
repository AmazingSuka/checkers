defmodule Checkers.Search do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: Checkers.Search)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call(:game_queue, _from, [] = state) do
    {:reply, {:empty, state}, state}
  end

  def handle_call(:game_queue, _from, state) do
    {:reply, {:ok, state}, state}
  end

  # What`s happen when two users start find together?
  def handle_cast({:reserve, socket}, state) do
    {:noreply, [socket | state]}
  end

  def handle_cast({:remove, socket}, state) do
    {:noreply, List.delete(state, socket)}
  end
end
