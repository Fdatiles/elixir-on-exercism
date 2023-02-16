defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when is_integer(count) and count >= 1 do
    Stream.iterate(2, &(&1 + 1))
    |> Stream.transform([], fn n, primes ->
      if Enum.all?(primes, &(rem(n, &1) != 0)) do
        {[n], [n | primes]}
      else
        {[], primes}
      end
    end)
    |> Enum.fetch!(count - 1)
  end
end
