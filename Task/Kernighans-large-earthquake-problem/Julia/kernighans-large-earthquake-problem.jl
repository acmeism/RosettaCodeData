using DataFrames, CSV

df = CSV.File("kernighansproblem.txt", delim=" ", ignorerepeated=true,
    header=["Date", "Location", "Magnitude"], types=[DateTime, String, Float64],
    dateformat="mm/dd/yyyy") |> DataFrame

println(filter(row -> row[:Magnitude] > 6, df))
