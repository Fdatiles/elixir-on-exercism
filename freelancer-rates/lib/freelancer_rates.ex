defmodule FreelancerRates do
  @hours_per_day 8.0
  @billable_days_per_month 22.0

  def daily_rate(hourly_rate) do
    @hours_per_day * hourly_rate
  end

  def apply_discount(before_discount, discount) do
    before_discount * (1 - discount / 100)
  end

  def monthly_rate(hourly_rate, discount) do
    @billable_days_per_month * daily_rate(hourly_rate)
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    budget / (daily_rate(hourly_rate) |> apply_discount(discount))
    |> Float.floor(1)
  end
end
