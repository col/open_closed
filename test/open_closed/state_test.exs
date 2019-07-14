defmodule OpenClosed.StateTest do
  use ExUnit.Case
  alias OpenClosed.State
  doctest OpenClosed.State

  describe "winner?" do
    test "returns true when the players prediction is correct" do
      state = %State{player_input: "CO2", ai_input: "CO", predictor: :player}
      assert State.winner?(state) == true
    end

    test "returns false when the players prediction is incorrect" do
      state = %State{player_input: "CO4", ai_input: "CO", predictor: :player}
      assert State.winner?(state) == false
    end

    test "returns true when the AI prediction is correct" do
      state = %State{player_input: "CO", ai_input: "CO2", predictor: :ai}
      assert State.winner?(state) == true
    end

    test "returns false when the AI prediction is incorrect" do
      state = %State{player_input: "CO", ai_input: "CO4", predictor: :ai}
      assert State.winner?(state) == false
    end
  end

  describe "prediction" do
    test "returns the prediction from the player_input when predictor" do
      state = %State{player_input: "CO1", ai_input: "CO", predictor: :player}
      assert State.prediction(state) == 1
    end

    test "returns the prediction from the ai_input when NOT predictor" do
      state = %State{player_input: "CO", ai_input: "CO2", predictor: :ai}
      assert State.prediction(state) == 2
    end
  end

end
