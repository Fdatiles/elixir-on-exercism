defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({na, da}, {nb, db}) do
    {na * db + nb * da, da * db} |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({na, da}, {nb, db}) do
    add({na, da}, {-nb, db}) |> reduce()
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({na, da}, {nb, db}) do
    {na * nb, da * db} |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({na, da}, {nb, db}) do
    {na * db, da * nb} |> reduce()
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({num, den}) do
    {Kernel.abs(num), Kernel.abs(den)} |> reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational(a, n)
  def pow_rational({num, den}, n) when n < 0, do: pow_rational({den, num}, -n)

  def pow_rational(a, n) do
    {num, den} = reduce(a)
    {num ** n, den ** n}
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {num, den}) do
    x ** (num / den)
  end

  defp gcd(a, b)
  defp gcd(a, b) when a < 0, do: gcd(-a, b)
  defp gcd(a, b) when b < 0, do: gcd(a, -b)
  defp gcd(0, b), do: b
  defp gcd(a, 0), do: a
  defp gcd(a, b) when a > b, do: gcd(b, rem(a, b))
  defp gcd(a, b), do: gcd(a, rem(b, a))

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce(a)
  def reduce({num, den}) when den < 0, do: reduce({-num, -den})

  def reduce({num, den}) do
    g = gcd(num, den)
    {div(num, g), div(den, g)}
  end
end
