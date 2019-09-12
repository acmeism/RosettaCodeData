property text item delimiters : {", ", "T"}

set shortdate to text item 1 of (the (current date) as «class isot» as string)

set [w, m, d, y] to the [weekday, month, day, year] of (the current date)
set longdate to {w, [m, space, d], y} as text

shortdate & linefeed & longdate
