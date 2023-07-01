set {year:y, month:m, day:d, weekday:w} to (current date)

tell (y * 10000 + m * 100 + d) as text to set shortFormat to text 1 thru 4 & "-" & text 5 thru 6 & "-" & text 7 thru 8
set longFormat to (w as text) & (", " & m) & (space & d) & (", " & y)

return (shortFormat & linefeed & longFormat)
