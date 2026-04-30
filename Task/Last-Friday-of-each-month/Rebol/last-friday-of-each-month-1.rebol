leap-year?:  function [year] [to-logic attempt [to-date reduce [29 2 year]]]

days-in-feb: function [year] [either leap-year? year [29] [28]]

days-in-month: function [month year] [
    do pick [31 (days-in-feb year) 31 30 31 30 31 31 30 31 30 31] month
]

last-day-of-month: function [month year] [
    to-date reduce [year month  days-in-month month year]
]

last-weekday-of-month: function [weekday month year] [
    d: last-day-of-month month year
    while [d/weekday != weekday] [d/day: d/day - 1]
    d
]

last-friday-of-month: function [month year] [last-weekday-of-month 5 month year]

year: to-integer input
repeat month 12 [print last-friday-of-month month year]
