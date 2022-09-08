defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts()} | {:error, error()}

  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation

      def init(opts), do: {:ok, opts}

      defoverridable(init: 1)
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    if Integer.mod(frame_number, 4) == 0,
      do: Map.update!(dot, :opacity, &(&1 / 2)),
      else: dot
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    case Keyword.get(opts, :velocity) do
      v when is_number(v) ->
        {:ok, opts}

      v ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(v)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    Map.update!(dot, :radius, fn radius ->
      radius + (frame_number - 1) * Keyword.fetch!(opts, :velocity)
    end)
  end
end
