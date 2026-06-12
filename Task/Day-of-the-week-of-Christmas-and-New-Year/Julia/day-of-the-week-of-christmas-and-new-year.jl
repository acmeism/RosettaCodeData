using Dates

for year in [1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393]
    println("Year $year, New Years's Day: ", Dates.format(DateTime(year, 1, 1), "E, U d, Y"),
        " and Christmas: ", Dates.format(DateTime(year, 12, 25), "E, U d, Y"))
end
