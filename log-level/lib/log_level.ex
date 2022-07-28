defmodule LogLevel do
  @log_labels %{
    0 => :trace,
    1 => :debug,
    2 => :info,
    3 => :warning,
    4 => :error,
    5 => :fatal,
    6 => :unknown
  }
  @supported_in_legacy 1..4

  def to_label(level, legacy?) do
    cond do
      legacy? and level not in @supported_in_legacy -> :unknown
      true -> Map.get(@log_labels, level, :unknown)
    end
  end

  def alert_recipient(level, legacy?) do
    case to_label(level, legacy?) do
      l when l in [:error, :fatal] -> :ops
      :unknown when legacy? -> :dev1
      :unknown -> :dev2
      _ -> false
    end
  end
end
