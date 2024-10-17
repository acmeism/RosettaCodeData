const dates = [[15, "May"], [16, "May"], [19, "May"], [17, "June"], [18, "June"],
    [14, "July"], [16, "July"], [14, "August"], [15, "August"], [17, "August"]]

uniqueday(parr) = filter(x -> count(y -> y[1] == x[1], parr) == 1, parr)

# At the start, they come to know that they have no unique day of month to identify.
const f1 = filter(m -> !(m[2] in [d[2] for d in uniqueday(dates)]), dates)

# After cutting months with unique dates, get months remaining that now have a unique date.
const f2 = uniqueday(f1)

# filter for those of the finally remaining months that have only one date left.
const bday = filter(x -> count(m -> m[2] == x[2], f2) == 1, f2)[]

println("Cheryl's birthday is $(bday[2]) $(bday[1]).")
