using Dates

lo, hi = 2008, 2121
xmas = collect(Date(lo, 12, 25):Year(1):Date(hi, 12, 25))
filter!(xmas) do dt
    dayofweek(dt) == Dates.Sunday
end

println("Years from $lo to $hi having Christmas on Sunday: ")
foreach(println, year.(xmas))
