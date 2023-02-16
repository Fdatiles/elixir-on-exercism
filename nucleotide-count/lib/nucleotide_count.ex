defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @type nucleotide :: unquote(Enum.reduce(@nucleotides, &{:|, [], [&1, &2]}))

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist, nucleotide) :: non_neg_integer
  def count(strand, nucleotide) when is_list(strand) and nucleotide in @nucleotides do
    Enum.count(strand, &(&1 === nucleotide))
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist) :: %{nucleotide => non_neg_integer}
  def histogram(strand) when is_list(strand) do
    empty_hist = Map.from_keys(@nucleotides, 0)

    Enum.reduce(strand, empty_hist, fn nucleotide, hist ->
      Map.update!(hist, nucleotide, &(&1 + 1))
    end)
  end
end
