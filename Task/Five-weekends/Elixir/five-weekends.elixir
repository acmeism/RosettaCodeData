defmodule Date do
  @months { "January", "February", "March",     "April",   "May",      "June",
            "July",    "August",   "September", "October", "November", "December" }

  def five_weekends(year) do
    for m <-[1,3,5,7,8,10,12], :calendar.day_of_the_week(year, m, 31) == 7, do: elem(@months, m-1)
  end
end

months = Enum.map(1900..2100, fn year -> {year, Date.five_weekends(year)} end)
{none, months5} = Enum.partition(months, fn {_,m} -> Enum.empty?(m) end)
count = Enum.reduce(months5, 0, fn {year, months}, acc ->
  IO.puts "#{year} : #{Enum.join(months, ", ")}"
  acc + length(months)
end)
IO.puts "Found #{count} month with 5 weekends."
IO.puts "\nFound #{length(none)} years with no month having 5 weekends:"
IO.puts "#{inspect Enum.map(none, fn {y,_}-> y end)}"
