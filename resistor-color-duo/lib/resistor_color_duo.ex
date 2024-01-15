defmodule ResistorColorDuo do
  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value(colors)

  def value(colors) when length(colors) >= 2 do
    colors
    |> Enum.take(2)
    |> Enum.reduce(0, fn color, acc ->
      acc * 10 + color_value(color)
    end)
  end

  @spec color_value(color :: atom) :: integer
  defp color_value(color) do
    case color do
      :black -> 0
      :brown -> 1
      :red -> 2
      :orange -> 3
      :yellow -> 4
      :green -> 5
      :blue -> 6
      :violet -> 7
      :grey -> 8
      :white -> 9
    end
  end
end
