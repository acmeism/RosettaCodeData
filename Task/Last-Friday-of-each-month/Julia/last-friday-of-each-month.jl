using Dates

const wday = Dates.Fri
const lo = 1
const hi = 12

print("\nThis script will print the last ", Dates.dayname(wday))
println("s of each month of the year given.")
println("(Leave input empty to quit.)")

while true
    print("\nYear> ")
    y = chomp(readline())
    0 < length(y) || break
    y = try
        parseint(y)
    catch
        println("Sorry, but \"", y, "\" does not compute as a year.")
        continue
    end
    println()
    for m in Date(y, lo):Month(1):Date(y, hi)
        println("    ", tolast(m, wday))
    end
end
