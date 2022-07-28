defmodule LibraryFees do
  @loan_period 28

  @spec datetime_from_string(String.t()) :: NaiveDateTime.t()
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  @spec before_noon?(NaiveDateTime.t()) :: boolean
  def before_noon?(datetime), do: datetime.hour < 12

  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime) do
    if before_noon?(checkout_datetime) do
      checkout_datetime |> NaiveDateTime.to_date() |> Date.add(@loan_period)
    else
      checkout_datetime |> NaiveDateTime.to_date() |> Date.add(@loan_period + 1)
    end
  end

  @spec days_late(Date.t(), NaiveDateTime.t()) :: integer
  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  @spec monday?(NaiveDateTime.t()) :: boolean
  def monday?(datetime), do: Date.day_of_week(datetime) === 1

  @spec calculate_late_fee(String.t(), String.t(), number) :: number
  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    actual_return_datetime = datetime_from_string(return)
    discount = if monday?(actual_return_datetime), do: 0.5, else: 0

    checkout_datetime
    |> return_date()
    |> days_late(actual_return_datetime)
    |> Kernel.*((1 - discount) * rate)
    |> floor()
  end
end
