defmodule OpenClosed.State do

  defstruct predictor: true, prediction: nil, player_input: nil, ai_input: nil, winner: nil

  @doc """
  Set the players input

  ## Examples
      iex> State.set_player_input(%State{}, "CO")
      %State{player_input: "CO"}
  """
  def set_player_input(state, value) do
    Map.put(state, :player_input, value)
  end

  @doc """
  Set the AI input

  ## Examples
      iex> State.set_ai_input(%State{}, "OO")
      %State{ai_input: "OO"}
  """
  def set_ai_input(state, value) do
    Map.put(state, :ai_input, value)
  end

  def set_winner(state, value) do
    Map.put(state, :winner, value)
  end

  def set_predictor(state, value) do
    Map.put(state, :predictor, value)
  end

  def set_prediction(state, value) do
    Map.put(state, :prediction, value)
  end

  def num_open(state, value) do
    2 # TODO: num_open
  end
end
