defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when is_list(strand1) and is_list(strand2) do
    do_hamming_distance(strand1, strand2)
  end

  @spec do_hamming_distance([char], [char], non_neg_integer) ::
          {:ok, non_neg_integer} | {:error, String.t()}

  defp do_hamming_distance(strand1, strand2, distance \\ 0)

  defp do_hamming_distance([a | t1], [a | t2], distance),
    do: do_hamming_distance(t1, t2, distance)

  defp do_hamming_distance([_ | t1], [_ | t2], distance),
    do: do_hamming_distance(t1, t2, distance + 1)

  defp do_hamming_distance([], [], distance), do: {:ok, distance}

  defp do_hamming_distance(strand1, strand2, _) when strand1 == [] or strand2 == [] do
    {:error, "strands must be of equal length"}
  end
end
