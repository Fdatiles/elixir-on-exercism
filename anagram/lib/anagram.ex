defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base_downcase = String.downcase(base)
    letters = count_letters(base_downcase)

    candidates
    |> Enum.map(&{String.downcase(&1), &1})
    |> Enum.filter(fn {down, _original} ->
      count_letters(down) == letters and down != base_downcase
    end)
    |> Enum.uniq_by(fn {down, _original} -> down end)
    |> Enum.map(fn {_, original} -> original end)
  end

  @spec count_letters(String.t()) :: %{String.t() => integer}
  defp count_letters(string) do
    string
    |> String.graphemes()
    |> Enum.frequencies()
  end
end
