defmodule OpenClosed do
  @moduledoc """
  Documentation for OpenClosed.
  """

  alias OpenClosed.State

  def main(_args) do
    @output.puts("Welcome to the Open Closed Game!")
    run()
  end

  def run(state \\ %State{}, io \\ IO) do
    play_round(state)
    case play_again?() do
      true ->
        run()
      _ ->
        io.puts "Ok, bye!"
    end
  end

  def play_round(state) do
    state
      |> get_player_input()
      |> get_ai_input()
      |> calc_winner()

    if !state.winner do
      State.set_predictor(state, !state.predictor) |> play_round()
    end
  end

  # tested
  def play_again?(io \\ IO) do
    input = io.gets "Do you want to play again? Y or N\n"
    input == "Y"
  end

  def calc_winner(state = %{predictor: true}) do
    winner = State.num_open(state) == state.prediction
    State.set_winner(state, winner)
  end

  def get_player_input(state, io \\ IO) do
    input = io.gets input_prompt(state.predictor)
    case parse_input(input, state.predictor) do
      {:ok, opened, prediction} ->
        state
          |> State.set_player_input(opened)
          |> State.set_prediction(prediction)
      {:error, message} ->
        io.puts message
        get_player_input(state, io)
    end
  end

  def get_ai_input(state, _io \\ IO) do
    state
      |> State.set_ai_input(2)
      |> State.set_prediction(2)
  end

  def input_prompt(true), do: "You are the predictor, what is your input?\n"
  def input_prompt(false), do: "AI is the predictor, what is your input?\n"

  def input_regex(predictor), do: ~r/[C|O][C|O]/
  def input_regex(predictor), do: ~r/[C|O][C|O][1-4]/

  def parse_input(input, predictor) when is_binary(input) do
    case String.match?(input, input_regex(predictor)) do
      false ->
        {:error, "Invalid input"}
      true ->
        {:ok, num_open(input), prediction(input, predictor)}
    end
  end
  def parse_input(_input, _predictor), do: {:error, "Invalid input"}

  def prediction(input, true) do
    input |> String.last() |> String.to_integer()
  end
  def prediction(_input, _predictor), do: nil

  def num_open(input) do
    input
      |> String.to_charlist()
      |> Enum.count(fn item -> [item] == 'O' end)
  end
end
