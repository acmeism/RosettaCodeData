#!/usr/bin/env rebol

last-sundays-of-year: function [
    "Return series of last sunday (date!) for each month of the year"
    year [integer!] "which year?"
  ][
    d: to-date reduce [1 1 year]            ; start with first day of year
    collect [
        repeat month 12 [
            d/month: month + 1              ; move to start of next month
            keep d - d/weekday              ; calculate last sunday & keep
        ]
    ]
]

foreach sunday last-sundays-of-year to-integer system/script/args [print sunday]
