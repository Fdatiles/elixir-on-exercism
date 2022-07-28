defmodule RemoteControlCar do
  @type t() :: %__MODULE__{
          battery_percentage: non_neg_integer,
          distance_driven_in_meters: non_neg_integer,
          nickname: String.t()
        }

  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  @spec new(String.t()) :: t()
  def new(nickname \\ "none"), do: %__MODULE__{nickname: nickname}

  @spec display_distance(t()) :: String.t()
  def display_distance(%__MODULE__{distance_driven_in_meters: d} = _remote_car),
    do: "#{d} meters"

  @spec display_battery(t()) :: String.t()
  def display_battery(%__MODULE__{battery_percentage: 0} = _remote_car), do: "Battery empty"
  def display_battery(%__MODULE__{battery_percentage: b} = _remote_car), do: "Battery at #{b}%"

  @spec drive(t()) :: t()
  def drive(%__MODULE__{battery_percentage: b} = remote_car) when b == 0, do: remote_car

  def drive(%__MODULE__{battery_percentage: b, distance_driven_in_meters: d} = remote_car)
      when b > 0 do
    %{remote_car | distance_driven_in_meters: d + 20, battery_percentage: b - 1}
  end
end
