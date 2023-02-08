defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    list
    |> do_flatten([])
    |> Enum.reverse
  end

  defp do_flatten(list, acc)
  # Returns the result reversed
  # This allows the previous level of nesting to use it as its new accumulator without reversing it again
  defp do_flatten([], acc), do: acc
  defp do_flatten([nil | t], acc), do: do_flatten(t, acc)
  defp do_flatten([h | t], acc) when is_list(h), do: do_flatten(t, do_flatten(h, acc))
  defp do_flatten([e | t], acc), do: do_flatten(t, [e | acc])
end
