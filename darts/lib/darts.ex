defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y} = p) when is_number(x) and is_number(y) do
    r = distance_to_center(p)
    cond do
      r <= 1 -> 10
      r <= 5 -> 5
      r <= 10 -> 1
      true -> 0
    end
  end

  @spec distance_to_center(position) :: float()
  defp distance_to_center({x, y}) when is_number(x) and is_number(y) do
    :math.sqrt(x ** 2 + y ** 2)
  end
end
