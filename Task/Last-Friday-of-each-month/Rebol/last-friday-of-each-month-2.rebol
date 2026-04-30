last-fridays-of-year: function [year] [
    collect [
        repeat month 12 [
            d: to-date reduce [1 month year]
            d/month: d/month + 1                      ; start of next month
            until [d/day: d/day - 1  d/weekday = 5]   ; go backwards until find a Friday
            keep d
        ]
    ]
]

foreach friday last-fridays-of-year to-integer input [print friday]
