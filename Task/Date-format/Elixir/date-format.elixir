defmodule Date_format do
  def iso_date, do: Date.utc_today |> Date.to_iso8601

  def iso_date(year, month, day), do: Date.from_erl!({year, month, day}) |> Date.to_iso8601

  def long_date, do: Date.utc_today |> long_date

  def long_date(year, month, day), do: Date.from_erl!({year, month, day}) |> long_date

  @months  Enum.zip(1..12, ~w[January February March April May June July August September October November December])
           |> Map.new
  @weekdays  Enum.zip(1..7, ~w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday])
             |> Map.new
  def long_date(date) do
    weekday = Date.day_of_week(date)
    "#{@weekdays[weekday]}, #{@months[date.month]} #{date.day}, #{date.year}"
  end
end

IO.puts Date_format.iso_date
IO.puts Date_format.long_date
IO.puts Date_format.iso_date(2007,11,10)
IO.puts Date_format.long_date(2007,11,10)
