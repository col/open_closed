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
      assert capture_io(fn ->
        OpenClosed.play_again?
      end) == "Do you want to play again? Y or N\n"
    end

    test "returns true when the user enters 'Y'" do
      capture_io("Y", fn ->
        assert OpenClosed.play_again? == true
      end)
    end

    test "returns false when the user enters 'N'" do
      capture_io("N", fn ->
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
  end

  describe "get_player_input when the player is NOT the predictor" do
    setup [:ai_is_predictor]

    test "prompts the user", %{state: state} do
      assert capture_io("CC", fn ->
        OpenClosed.get_player_input(state)
      end) == "AI is the predictor, what is your input?\n"
    end
  end

  describe "parse_input" do
    test "parses 'CC'" do
      assert {:ok, 0, nil} = OpenClosed.parse_input("CC", false)
    end

    test "parses 'CO'" do
      assert {:ok, 1, nil} = OpenClosed.parse_input("CO", false)
    end

    test "parses 'OC'" do
      assert {:ok, 1, nil} = OpenClosed.parse_input("OC", false)
    end

    test "parses 'OO'" do
      assert {:ok, 2, nil} = OpenClosed.parse_input("OO", false)
    end

    test "parses 'CC1'" do
      assert {:ok, 0, 1} = OpenClosed.parse_input("CC1", true)
    end

    test "parses 'CO2'" do
      assert {:ok, 1, 2} = OpenClosed.parse_input("CO2", true)
    end

    test "parses 'OC3'" do
      assert {:ok, 1, 3} = OpenClosed.parse_input("OC3", true)
    end

    test "parses 'OO4'" do
      assert {:ok, 2, 4} = OpenClosed.parse_input("OO4", true)
    end

    test "returns error for invalid input" do
      assert {:error, "Invalid input"} = OpenClosed.parse_input("chicken", false)
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
