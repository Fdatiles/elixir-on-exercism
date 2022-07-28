defmodule RPNCalculator.Exception do
  @type stack :: [number]

  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(term)
    def exception([]), do: %__MODULE__{}

    def exception(term) when is_binary(term),
      do: %__MODULE__{message: "stack underflow occurred, context: " <> term}
  end

  @spec divide(stack) :: float
  def divide(stack)
  def divide([0, _ | _]), do: raise(DivisionByZeroError)
  def divide([a, b | _]), do: b / a
  def divide(stack) when is_list(stack), do: raise(StackUnderflowError, "when dividing")
end
