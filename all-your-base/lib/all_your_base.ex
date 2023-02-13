defmodule AllYourBase do
  @type digits :: [integer]
  @type base :: integer

  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """
  @spec convert(digits, base, base) :: {:ok, digits} | {:error, String.t()}
  def convert(digits, input_base, output_base)
      when is_integer(input_base) and is_integer(output_base) and is_list(digits) do
    case {input_base, output_base} do
      {_, o} when o < 2 -> {:error, "output base must be >= 2"}
      {i, _} when i < 2 -> {:error, "input base must be >= 2"}
      {_, _} -> convert_guarded(digits, input_base, output_base)
    end
  end

  @spec convert_guarded(digits, base, base) :: {:ok, digits} | {:error, String.t()}
  defp convert_guarded(digits, input_base, output_base) do
    case parse_integer(digits, input_base) do
      {:ok, integer} -> write_integer(integer, output_base)
      {:error, _} = e -> e
    end
  end

  @spec parse_integer(digits, integer) :: {:ok, integer} | {:error, String.t()}
  defp parse_integer(digits, base) do
    out =
      Enum.reduce_while(digits, 0, fn
        digit, acc when digit in 0..(base-1) -> {:cont, digit + acc * base}
        _, _ -> {:halt, nil}
      end)

    case out do
      nil -> {:error, "all digits must be >= 0 and < input base"}
      i -> {:ok, i}
    end
  end

  @spec write_integer(base, base, digits) :: {:ok, digits}
  defp write_integer(integer, base, acc \\ [])
  defp write_integer(0, _base, []), do: {:ok, [0]}
  defp write_integer(0, _base, acc), do: {:ok, acc}

  defp write_integer(integer, base, acc) do
    write_integer(div(integer, base), base, [rem(integer, base) | acc])
  end
end
