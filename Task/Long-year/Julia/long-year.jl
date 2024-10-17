using Dates

has53weeks(year) = week(Date(year, 12, 28)) == 53

println(" Year  53 weeks?\n----------------")
for year in 1990:2021
    println(year, "   ", has53weeks(year) ? "Yes" : "No")
end
