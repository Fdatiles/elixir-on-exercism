# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> {1, []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_next_id, list} -> list end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {next_id, list} ->
      new_plot = %Plot{plot_id: next_id, registered_to: register_to}
      {new_plot, {next_id + 1, [new_plot | list]}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {next_id, list} ->
      {next_id, Enum.reject(list, fn %Plot{plot_id: id} -> id == plot_id end)}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {_next_id, list} ->
      Enum.find(
        list,
        {:not_found, "plot is unregistered"},
        fn %Plot{plot_id: id} -> id == plot_id end
      )
    end)
  end
end
