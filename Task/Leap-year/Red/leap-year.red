leapyear?: function [
    "returns true for a leap year."
    date [date!]
][
    year: date/year
    if zero? year // 400 and year / 100 [return true]
    if zero? year // 4 [return true]
    false
]
