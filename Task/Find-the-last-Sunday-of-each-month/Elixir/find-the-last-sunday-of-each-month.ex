defmodule RC do
  def lastSunday(year) do
    Enum.map(1..12, fn month ->
      lastday = :calendar.last_day_of_the_month(year, month)
      daynum = :calendar.day_of_the_week(year, month, lastday)
      sunday = lastday - rem(daynum, 7)
      {year, month, sunday}
    end)
  end
end

y = String.to_integer(hd(System.argv))
Enum.each(RC.lastSunday(y), fn {year, month, day} ->
  :io.format "~4b-~2..0w-~2..0w~n", [year, month, day]
end)
