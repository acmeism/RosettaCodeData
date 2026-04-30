leap-year?: func [
    {Returns true if the specified year is a leap year; false otherwise.}
    year [date! integer!]
][
    ;; If the input is a date!, extract just the year component
    if date? year [year: year/year]
    ;; Validate that the year is not negative
    assert [not negative? year]
    ;; If divisible by 100...
    if zero? year // 100 [
        ;; ... it's a leap year only if divisible by 400
        return zero? year // 400
    ]
    ;; Otherwise, it's a leap year if divisible by 4
    zero? year // 4
]
print "Leap year examples:"
foreach year [
    1600 ;(divisible by 400, so leap year)
    1704
    1808
    1904
    2000 ;(divisible by 400, leap year even though it’s a century)
    2004
    2008
    2012
    2016
    2020
    2024
    2028
    2400 ;(way in the future, still divisible by 400)
][
    print [tab year leap-year? year]
]
print "Not leap year examples:"
foreach year [1700 1800 1900 2025][
    print [tab year leap-year? year]
]
