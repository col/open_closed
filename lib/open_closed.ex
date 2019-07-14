defmodule OpenClosed do
  @moduledoc """
  Documentation for OpenClosed.
  """

  alias OpenClosed.State

  def main(_args) do
    IO.puts("Welcome to the Open Closed Game!")
    run()
  end

  def run(state \\ %State{}, io \\ IO) do
    play_round(state)
    case play_again?() do
      true ->
        run(%State{}, io)
      _ ->
        io.puts "Ok, bye!"
    end
  end

  def play_round(state, io \\ IO) do
    state = state
      |> get_player_input()
      |> get_ai_input()

    io.puts "AI: #{state.ai_input}"

    if State.winner?(state) do
      output_winner(state, io)
    else
      io.puts "No winner."
      State.set_predictor(state, !state.predictor)
      |> play_round(io)
    end
  end

  def output_winner(state, io \\ IO)
  def output_winner(%{predictor: true}, io), do: io.puts "You WIN!"
  def output_winner(%{predictor: false}, io), do: io.puts "You LOSE!"

  def play_again?(io \\ IO) do
    input = "Do you want to play again? Y or N\n"
      |> io.gets()
      |> String.trim()
    input == "Y"
  end

  def get_player_input(state, io \\ IO) do
    input = input_prompt(state.predictor)
      |> io.gets()
      |> String.trim()
    case validate_input(input, state.predictor) do
      {:ok, input} ->
        State.set_player_input(state, input)
      {:error, message} ->
        io.puts message
        get_player_input(state, io)
    end
  end

  def get_ai_input(state, _io \\ IO) do
    input = random_input_char()<>random_input_char()
    case state.predictor do
      true ->
        State.set_ai_input(state, input)
      false ->
        State.set_ai_input(state, input<>random_prediction())
    end
  end

  defp random_input_char(), do: String.at("CO", :rand.uniform(2)-1)
  defp random_prediction(), do: String.at("1234", :rand.uniform(4)-1)

  def input_prompt(true), do: "You are the predictor, what is your input?\n"
  def input_prompt(false), do: "AI is the predictor, what is your input?\n"

  def input_regex(false), do: ~r/^[C|O][C|O]\Z/
  def input_regex(true), do: ~r/^[C|O][C|O][1-4]\Z/

  def validate_input(input, predictor) when is_binary(input) do
    case String.match?(input, input_regex(predictor)) do
      false ->
        {:error, "Invalid input"}
      true ->
        {:ok, input}
    end
  end
end
