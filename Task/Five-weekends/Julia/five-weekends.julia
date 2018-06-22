isweekend(dt::Date) = Dates.dayofweek(dt) ∈ (Dates.Friday, Dates.Saturday, Dates.Sunday)

function hasfiveweekend(month::Integer, year::Integer)
    dmin = Date(year, month, 1)
    dmax = dmin + Dates.Day(Dates.daysinmonth(dmin) - 1)
    return count(isweekend, dmin:dmax) ≥ 15
end

months = collect((y, m) for y in 1900:2100, m in 1:12 if hasfiveweekend(m, y))

println("Number of months with 5 full-weekends: $(length(months))")
println("First five such months:")
for (y, m) in months[1:5] println(" - $y-$m") end
println("Last five such months:")
for (y, m) in months[end-4:end] println(" - $y-$m") end

# extra credit
yrs = getindex.(months, 1)
nyrs = 2100 - 1899 - length(unique(yrs))

println("Number of year with not one 5-full-weekend month: $nyrs")
