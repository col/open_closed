defmodule OpenClosed.State do

  defstruct predictor: :player, player_input: nil, ai_input: nil

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
      iex> State.set_ai_input(%State{}, "CO")
      %State{ai_input: "CO"}
  """
  def set_ai_input(state, value) do
    Map.put(state, :ai_input, value)
  end

  @doc """
  Switches the predictor from :player to :ai or vice versa

  ## Examples
      iex> State.switch_predictor(%State{predictor: :player})
      %State{predictor: :ai}

      iex> State.switch_predictor(%State{predictor: :ai})
      %State{predictor: :player}
  """
  def switch_predictor(state) do
    case state.predictor do
      :player -> Map.put(state, :predictor, :ai)
      :ai -> Map.put(state, :predictor, :player)
    end
  end

  def winner?(state) do
    total_open(state) == prediction(state)
  end

  defp total_open(state) do
    parse_num_open(state.player_input) + parse_num_open(state.ai_input)
  end

  def prediction(state) do
    case state.predictor do
      :player -> parse_prediction(state.player_input)
      :ai -> parse_prediction(state.ai_input)
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
