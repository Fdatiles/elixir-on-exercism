defmodule TakeANumberDeluxe do
  use GenServer
  alias TakeANumberDeluxe.State

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
    :ok
  end

  # Server callbacks
  @impl GenServer
  @spec init(keyword) :: {:stop, atom()} | {:ok, State.t()}
  def init(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)

    with {:ok, state} <-
           State.new(
             min_number,
             max_number,
             auto_shutdown_timeout
           ) do
      {:ok, state, auto_shutdown_timeout}
    else
      {:error, e} -> {:stop, e}
    end
  end

  @impl GenServer
  def handle_call(request, from, state)

  def handle_call(:report_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  def handle_call(:queue_new_number, _from, state) do
    case State.queue_new_number(state) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}

      {:error, _} = e ->
        {:reply, e, state, state.auto_shutdown_timeout}
    end
  end

  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case State.serve_next_queued_number(state, priority_number) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}

      {:error, _} = e ->
        {:reply, e, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(request, state)

  def handle_cast(:reset_state, %State{
        min_number: min_number,
        max_number: max_number,
        auto_shutdown_timeout: auto_shutdown_timeout
      }) do
    {:ok, new_state} = State.new(min_number, max_number, auto_shutdown_timeout)
    {:noreply, new_state, auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_info(request, state)
  def handle_info(:timeout, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}
end
