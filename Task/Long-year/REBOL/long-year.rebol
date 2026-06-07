Rebol [
    title: "Rosetta code: Long year"
    file:  %Long_year.r3
    url:   https://rosettacode.org/wiki/Long_year
]

long-year?: function [
    "Determine if the year has 53 weeks."
    year [integer!]
][
    ;; Create date for January 1st of the given year
    jan1: make date! reduce [1 1 year]

    ;; Determine if the year is a leap year (Gregorian rules)
    leap?: all [
        0 == year mod 4
        any [
            0 != year mod 100
            0 == year mod 400
        ]
    ]
    ;; A year has 53 weeks if:
    any [
        jan1/weekday = 4      ;;Jan 1 is Thursday, or
        all [
            leap?             ;; It's a leap year
            jan1/weekday = 3  ;; and Jan 1 is Wednesday
        ]
    ]
]

print "Years with 53 weeks between 2000 and 2100:"
probe collect [
    for year 2000 2100 1 [
        ;; Keep years that satisfy the 53-week condition
        if long-year? year [keep year]
    ]
]
