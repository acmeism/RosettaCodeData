Enum.each(2008..2121, fn year ->
  wday = Date.from_erl!({year, 12, 25}) |> Date.day_of_week
  if wday==7, do: IO.puts "25 December #{year} is sunday"
end)
