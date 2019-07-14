defmodule OpenClosed.State do

  defstruct predictor: true, player_input: nil, ai_input: nil

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

  @doc """
  Sets the predictor flag

  ## Examples
      iex> State.set_predictor(%State{}, false)
      %State{predictor: false}
  """
  def set_predictor(state, value) do
    Map.put(state, :predictor, value)
  end

  def winner?(state) do
    total_open(state) == prediction(state)
  end

  defp total_open(state) do
    parse_num_open(state.player_input) + parse_num_open(state.ai_input)
  end

  def prediction(state) do
    case state.predictor do
      true ->
        parse_prediction(state.player_input)
      false ->
        parse_prediction(state.ai_input)
    end
  end

  defp parse_num_open(input) do
    input
      |> String.to_charlist()
      |> Enum.count(fn item -> [item] == 'O' end)
  end

  defp parse_prediction(input) do
    input |> String.last() |> String.to_integer()
  end
end
