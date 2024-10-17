module DoomsdayRule
export get_weekday

const weekdaynames = ["Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
# For months 1 through 12, the date of the first doomsday that month.
const leapyear_firstdoomsdays = [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
const nonleapyear_firstdoomsdays = [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]

"""
    get_weekday(year::Int, month::Int, day::Int)::String

Return the weekday of a given date in past or future.
Uses Conway's doomsday rule (see also https://en.wikipedia.org/wiki/Doomsday_rule)
"""
function get_weekday(year::Int, month::Int, day::Int)::String
    # sanity checks
    @assert 1582 <= year <= 9999 "Invalid year (should be after 1581 and 4 digits)"
    @assert 1 <= month <= 12 "Invalid month, should be between 1 and 12"
    @assert 1 <= day <= 31 "Invalid day, should be between 1 and 31"

    # Conway's doomsday algorithm
    doomsday = (2 + 5 * (year % 4) + 4 * (year % 100) + 6 * (year % 400)) % 7
    anchorday = (year % 4 != 0) || (year % 100 == 0 && year % 400 != 0) ?  # leap year determination
                 nonleapyear_firstdoomsdays[month] : leapyear_firstdoomsdays[month]
    weekday = (doomsday + day - anchorday + 7) % 7 + 1
    return weekdaynames[weekday]
end

end # module

using .DoomsdayRule

println("January 6, 1800 was on a ", get_weekday(1800, 1, 6))
println("March 29, 1875 was on a ", get_weekday(1875, 3, 29))
println("December 7, 1915 was on a ", get_weekday(1915, 12, 7))
println("December 23, 1970 was on a ", get_weekday(1970, 12, 23))
println("May 14, 2043 will be on a ", get_weekday(2043, 5, 14))
println("February 12, 2077 will be on a ", get_weekday(2077, 2, 12))
println("April 2, 2101 will be on a ", get_weekday(2101, 4, 2))
