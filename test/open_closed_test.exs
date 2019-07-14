defmodule OpenClosedTest do
  use ExUnit.Case
  alias OpenClosed.State
  import ExUnit.CaptureIO
  doctest OpenClosed

  setup do
    {:ok, state: %State{}}
  end

  describe "main" do
    test "play a winning game, then quit" do
      assert capture_io("CO2\nN\n", fn ->
        OpenClosed.main([])
      end) == """
      Welcome to the Open Closed Game!
      You are the predictor, what is your input?
      AI: CO
      You WIN!
      Do you want to play again? Y or N
      Ok, bye!
      """
    end

    test "lose, retry, and win" do
      assert capture_io("CO4\nCO\nY\nCO2\n", fn ->
        OpenClosed.main([])
      end) == """
      Welcome to the Open Closed Game!
      You are the predictor, what is your input?
      AI: CO
      No winner.
      AI is the predictor, what is your input?
      AI: CO2
      You LOSE!
      Do you want to play again? Y or N
      You are the predictor, what is your input?
      AI: CO
      You WIN!
      Do you want to play again? Y or N
      Ok, bye!
      """
    end
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
      end)
    end

    test "prints an error when input is invalid and re-prompts the user", %{state: state} do
      assert capture_io("chicken\nCO2\n", fn ->
        OpenClosed.get_player_input(state)
      end) == """
      You are the predictor, what is your input?
      Invalid input
      You are the predictor, what is your input?
      """
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
      assert {:ok, "CC"} = OpenClosed.validate_input("CC", :ai)
    end

    test "parses 'CO'" do
      assert {:ok, "CO"} = OpenClosed.validate_input("CO", :ai)
    end

    test "parses 'OC'" do
      assert {:ok, "OC"} = OpenClosed.validate_input("OC", :ai)
    end

    test "parses 'OO'" do
      assert {:ok, "OO"} = OpenClosed.validate_input("OO", :ai)
    end

    test "parses 'CC1'" do
      assert {:ok, "CC1"} = OpenClosed.validate_input("CC1", :player)
    end

    test "parses 'CO2'" do
      assert {:ok, "CO2"} = OpenClosed.validate_input("CO2", :player)
    end

    test "parses 'OC3'" do
      assert {:ok, "OC3"} = OpenClosed.validate_input("OC3", :player)
    end

    test "parses 'OO4'" do
      assert {:ok, "OO4"} = OpenClosed.validate_input("OO4", :player)
    end

    test "returns an error for invalid input" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("chicken", :ai)
    end

    test "returns an error when the prediction is missing" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("CO", :player)
    end

    test "returns an error if prediction provided when not predictor" do
      assert {:error, "Invalid input"} = OpenClosed.validate_input("CO1", :ai)
    end
  end

  defp player_is_predictor(%{state: state}) do
    {:ok, state: Map.put(state, :predictor, :player)}
  end

  defp ai_is_predictor(%{state: state}) do
    {:ok, state: Map.put(state, :predictor, :ai)}
  end
end
