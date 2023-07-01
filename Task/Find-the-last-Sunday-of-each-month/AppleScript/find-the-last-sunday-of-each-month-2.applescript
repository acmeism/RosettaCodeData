on lastSundayOfEachMonthInYear(y)
	-- Initialise an AppleScript date to the first day of some month in the specified year.
	tell (current date) to set {firstDayOfNextMonth, its day, its year} to {it, 1, y}
	
	-- Get a string representation of y, zero-padded if necessary, and initialise the output string.
	set y to text 2 thru 5 of ((10000 + y) as text)
	set outputText to "./last_sundays " & y
	repeat with nextMonth from 2 to 13 -- Yes!
		-- For each month in the year, get the first day of the following month.
		set firstDayOfNextMonth's month to nextMonth
		-- Calculate the date of the Sunday which occurs in the seven days prior to that
		-- by subtracting a day plus the difference between the previous day's weekday and the target weekday.
		set lastSundayOfThisMonth to firstDayOfNextMonth - (1 + ((firstDayOfNextMonth's weekday) + 5) mod 7) * days
		-- Append the required details to the output text.
		set {month:m, day:d} to lastSundayOfThisMonth
		tell (10000 + m * 100 + d) as text to ¬
			set outputText to outputText & (linefeed & y & "-" & text 2 thru 3 & "-" & text 4 thru 5)
	end repeat
	
	return outputText
end lastSundayOfEachMonthInYear

lastSundayOfEachMonthInYear(2020)
