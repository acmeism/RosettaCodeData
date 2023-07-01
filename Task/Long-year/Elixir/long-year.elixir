defmodule ISO do
  def long_year?(y) do
    {:ok, jan1} = Date.new(y,1,1)
    {:ok, dec31} = Date.new(y,12,31)
    Date.day_of_week(jan1) == 4 or Date.day_of_week(dec31) == 4
  end
end

IO.inspect(Enum.filter(1990..2050, &ISO.long_year?/1))
