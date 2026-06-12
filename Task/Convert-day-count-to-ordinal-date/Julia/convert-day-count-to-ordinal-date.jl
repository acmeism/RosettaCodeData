"""
Julia's `Dates` buitin module is based on the ISO 8601 standard, which follows the
proleptic Gregorian calendar with the exception that there is a year 0 at 1 BCE.
"""

using Dates

const epoch = Date(2000, 01, 01)
const modulus = 146097  # Number of days in a 400-year Gregorian cycle
pasttriplet(days) = epoch + Dates.Day((days - modulus) % modulus)
futuretriplet(days) = epoch + Dates.Day((days + modulus) % modulus)


println("Days from Epoch  Most Recent Past  Most Immediate Future\n", "="^56)
for days in [0, 109573, 146096]
    println(string(days, pad = 6), " "^11, pasttriplet(days), " "^8, futuretriplet(days))
end
