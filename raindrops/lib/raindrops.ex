defmodule Raindrops do
  @divisor_labels %{
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) when is_integer(number) and number > 0 do
    out =
      @divisor_labels
      |> Enum.sort_by(fn {k, _v} -> k end)
      |> Enum.map_join(fn {divisor, label} ->
        if rem(number, divisor) == 0 do
          label
        else
          ""
        end
      end)

    if out == "" do
      Integer.to_string(number)
    else
      out
    end
  end
end
