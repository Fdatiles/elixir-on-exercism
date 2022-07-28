defmodule TakeANumber do
  def start(), do: spawn(fn -> number_machine(0) end)

  defp number_machine(n) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, n)
        number_machine(n)

      {:take_a_number, sender_pid} ->
        send(sender_pid, n + 1)
        number_machine(n + 1)

      :stop -> nil

      _ -> number_machine(n)
    end
  end
end
