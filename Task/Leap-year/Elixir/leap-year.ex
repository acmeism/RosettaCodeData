leap_year? = fn(year) -> :calendar.is_leap_year(year) end
IO.inspect for y <- 2000..2020, leap_year?.(y), do: y
