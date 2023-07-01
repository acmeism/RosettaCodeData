on lastWeekdayWOfEachMonthInYear(w, y) -- Parameters: (AppleScript weekday constant, AD year number)
	-- Initialise an AppleScript date to the first day of some month in the specified year.
	tell (current date) to set {firstDayOfNextMonth, its day, its year} to {it, 1, y}
	
	-- Get a string representation of y, zero-padded if necessary, and initialise the output string.
	set y to text 2 thru 5 of ((10000 + y) as text)
	set outputText to "./last_" & w & "s " & y
	repeat with nextMonth from 2 to 13 -- Yes!
		-- For each month in the year, get the first day of the following month.
		set firstDayOfNextMonth's month to nextMonth
		-- Calculate the date of the target weekday which occurs in the seven days prior to that.
		-- The calculation can be described in various ways, the simplest being the subtraction of a day plus the difference between the previous day's weekday and the target weekday:
		--	firstDayOfNextMonth - (1 + (((firstDayOfNextMonth's weekday) - 1) - w + 7) mod 7) * days
		-- But they all boil down to:
		set lastWOfThisMonth to firstDayOfNextMonth - (1 + ((firstDayOfNextMonth's weekday) - w + 6) mod 7) * days
		-- Get the day and month of the calculated date and append the required details to the output text.
		set {month:m, day:d} to lastWOfThisMonth
		tell (10000 + m * 100 + d) as text to ¬
			set outputText to outputText & (linefeed & y & "-" & text 2 thru 3 & "-" & text 4 thru 5)
	end repeat
	
	return outputText
end lastWeekdayWOfEachMonthInYear

lastWeekdayWOfEachMonthInYear(Friday, 2020)
