defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """

  @doc """
  Generates the first `count` Lucas numbers.
  """
  @spec generate(pos_integer) :: list(pos_integer)
  def generate(count)

  def generate(count) when not is_integer(count) or count < 1,
    do: raise(ArgumentError, "count must be specified as an integer >= 1")

  def generate(1), do: [2]
  def generate(2), do: [2, 1]

  def generate(count) do
    Stream.unfold({2, 1}, fn {curr, _} = pair -> {curr, next_pair(pair)} end)
    |> Enum.take(count)
  end

  @spec next_pair({pos_integer, pos_integer}) :: {pos_integer, pos_integer}
  defp next_pair({prev, curr}), do: {curr, curr + prev}
end
