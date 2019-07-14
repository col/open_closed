defmodule OpenClosedTest do
  use ExUnit.Case
  alias OpenClosed.State
  import ExUnit.CaptureIO
  doctest OpenClosed

  setup do
    {:ok, state: %State{}}
  end

  describe "play_again" do
    test "prompts the user" do
      assert capture_io("\n", fn ->
        OpenClosed.play_again?
      end) == "Do you want to play again? Y or N\n"
    end

    test "returns true when the user enters 'Y'" do
      capture_io("Y\n", fn ->
        assert OpenClosed.play_again? == true
      end)
    end

    test "returns false when the user enters 'N'" do
      capture_io("N\n", fn ->
        assert OpenClosed.play_again? == false
      end)
    end
  end

  describe "get_player_input when the player is the predictor" do
    setup [:player_is_predictor]

    test "prompts the user", %{state: state} do
      assert capture_io("CC2", fn ->
        OpenClosed.get_player_input(state)
      end) == "You are the predictor, what is your input?\n"
    end

    test "sets the player_input", %{state: state} do
      capture_io("CC2\n", fn ->
        state = OpenClosed.get_player_input(state)
        assert state.player_input == "CC2"
      end) == "You are the predictor, what is your input?\n"
    end
  end

  describe "get_player_input when the player is NOT the predictor" do
    setup [:ai_is_predictor]

    test "prompts the user", %{state: state} do
      assert capture_io("CC", fn ->
        OpenClosed.get_player_input(state)
      end) == "AI is the predictor, what is your input?\n"
    end
  end

  describe "validate_input" do
    test "parses 'CC'" do
      assert {:ok, "CC"} = OpenClosed.validate_input("CC", false)
    end

    test "parses 'CO'" do
      assert {:ok, "CO"} = OpenClosed.validate_input("CO", false)
    end

    test "parses 'OC'" do
      assert {:ok, "OC"} = OpenClosed.validate_input("OC", false)
    end

    test "parses 'OO'" do
      assert {:ok, "OO"} = OpenClosed.validate_input("OO", false)
    end

    test "parses 'CC1'" do
      assert {:ok, "CC1"} = OpenClosed.validate_input("CC1", true)
    end

    test "parses 'CO2'" do
      assert {:ok, "CO2"} = OpenClosed.validate_input("CO2", true)
    end

    test "parses 'OC3'" do
      assert {:ok, "OC3"} = OpenClosed.validate_input("OC3", true)
    end

    test "parses 'OO4'" do
      assert {:ok, "OO4"} = OpenClosed.validate_input("OO4", true)
    end

    test "returns an error for invalid input" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("chicken", false)
    end

    test "returns an error when the prediction is missing" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("CO", true)
    end

    test "returns an error if prediction provided when not predictor" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("CO1", false)
    end
  end

  describe "parse_input when player is NOT predictor" do

  end

  defp player_is_predictor(%{state: state}) do
    {:ok, state: State.set_predictor(state, true)}
  end

  defp ai_is_predictor(%{state: state}) do
    {:ok, state: State.set_predictor(state, false)}
  end
end
