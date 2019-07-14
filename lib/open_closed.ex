defmodule OpenClosed do
  @moduledoc """
  Documentation for OpenClosed.
  """

  alias OpenClosed.State

  def main(_args) do
    IO.puts("Welcome to the Open Closed Game!")
    run(%State{})
  end

  def run(state) do
    play_round(state)
    case play_again?() do
      true -> run(%State{})
      _ -> IO.puts "Ok, bye!"
    end
  end

  def play_round(state) do
    state = state
      |> get_player_input()
      |> get_ai_input()

    IO.puts "AI: #{state.ai_input}"

    if State.winner?(state) do
      IO.puts winner_message(state)
    else
      IO.puts "No winner."
      State.switch_predictor(state)
        |> play_round()
    end
  end

  def play_again?() do
    case IO.gets("Do you want to play again? Y or N\n") do
      :eof -> false
      input -> String.trim(input) == "Y"
    end
  end

  def get_player_input(state) do
    input = input_prompt(state.predictor)
      |> IO.gets()
      |> String.trim()
    case validate_input(input, state.predictor) do
      {:ok, input} ->
        State.set_player_input(state, input)
      {:error, message} ->
        IO.puts message
        get_player_input(state)
    end
  end

  def get_ai_input(state) do
    State.set_ai_input(state, OpenClosed.AI.get_input(state.predictor))
  end

  def input_prompt(:player), do: "You are the predictor, what is your input?\n"
  def input_prompt(:ai), do: "AI is the predictor, what is your input?\n"

  def input_regex(:player), do: ~r/^[C|O][C|O][1-4]\Z/
  def input_regex(:ai), do: ~r/^[C|O][C|O]\Z/

  def validate_input(input, predictor) when is_binary(input) do
    case String.match?(input, input_regex(predictor)) do
      false ->
        {:error, "Invalid input"}
      true ->
        {:ok, input}
    end
  end

  @doc """
  Returns the winning message

  ## Examples
      iex> OpenClosed.winner_message(%State{predictor: :player})
      "You WIN!"

      iex> OpenClosed.winner_message(%State{predictor: :ai})
      "You LOSE!"
  """
  def winner_message(%{predictor: :player}), do: "You WIN!"
  def winner_message(%{predictor: :ai}), do: "You LOSE!"
end
