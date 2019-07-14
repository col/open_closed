defmodule OpenClosed.StateTest do
  use ExUnit.Case
  alias OpenClosed.State

  test "set_player_input/2" do
    state = %State{player_input: "XX"}
    state = State.set_player_input(state, "CC")
    assert state.player_input == "CC"
  end
end
