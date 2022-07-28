defmodule RPNCalculatorInspection do
  @type status :: :ok | :error | :timeout
  @type input :: String.t()
  @type calculator :: (input -> number)
  @type status_map :: %{input => status}

  @spec start_reliability_check(calculator, input) :: %{input: input, pid: pid}
  def start_reliability_check(calculator, input) do
    %{pid: spawn_link(fn -> calculator.(input) end), input: input}
  end

  @spec await_reliability_check_result(%{input: input, pid: pid}, status_map) :: status_map
  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  @spec reliability_check(calculator, list(input)) :: status_map
  def reliability_check(calculator, inputs) do
    old_flag = Process.flag(:trap_exit, true)

    result =
      inputs
      |> Enum.map(&start_reliability_check(calculator, &1))
      |> Enum.reduce(%{}, &await_reliability_check_result/2)

    _ = Process.flag(:trap_exit, old_flag)

    result
  end

  @spec correctness_check(calculator, list(input)) :: list(number)
  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
