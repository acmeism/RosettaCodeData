"Instance Variables:
- yearToPrint: The year to print the calendar of
- stream: The stream used to print the calendar
- monthsOfYear: A collection of all the months of yearToPrint, for example January 1969, February 1969, and so on
- currentMonths: Group of 3 months under print, for example from January to March or April to June, and so on
- monthOfYearCurrentDate: A collection that associates a month with the date to print for that month. It is used to
  know which day number should be printed for each month when iterating over the day of weeks of each row"
Object subclass: #CalendarPrinter
	instanceVariableNames: 'yearToPrint stream monthsOfYear currentMonths monthOfYearCurrentDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CalendarPrinter'

CalendarPrinter class>>printOnTranscriptForYearNumber: aYearNumber
	(self for: (GregorianYear number: aYearNumber) on: Transcript) value

CalendarPrinter class>>for: aYear on: aStream
  	^self new initializeFor: aYear on: aStream

initializeFor: aYear on: aStream
	yearToPrint := aYear.
	stream := aStream.	
	monthsOfYear := yearToPrint months.
	monthOfYearCurrentDate := monthsOfYear collect: [ :aMonthOfYear | aMonthOfYear firstDate ].

value
	"Prints the year number (header) and then its months"
	self
		printHeader;
		printMonths.

printHeader
	"Prints the year number centered"
	self center: yearToPrint number printString in: self numberOfCharactersPerLine.
	stream newLine; newLine.

printMonths
	"Prints each group of 3 months, for example from January to March, then April to June and so on"
	(January to: December by: 3*month) do: [ :aMonth | self printMonthsStartingOn: aMonth ].

printMonthsStartingOn: aMonth
	"For each group of 3 months starting in aMonth, prints the name of the month (header),
	the name of the days of the week (Mo Tu ...), and then the day numbers"
	currentMonths := aMonth to: aMonth next next.
	self
		printMonthsHeader;
		printDaysOfWeekHeader;
		printDayNumbers.	

printMonthsHeader
	"Prints the current group of 3 months names, centered"
	currentMonths
		do: [ :currentMonth | self center: currentMonth printString in: self numberOfCharactersPerMonth ]
		separatedBy: [ stream space: 3 ].
	stream newLine.

printDaysOfWeekHeader
	"Prints the names of the days of week for each month of the current group of 3 months"
	currentMonths
		do: [ :currentMonth | self printOneMonthDaysOfWeekHeader ]
		separatedBy: [ stream space: 3 ].
	stream newLine.

printOneMonthDaysOfWeekHeader
	"Prints the name of the days of week"
	(Sunday to: Saturday)
		do: [ :aDayOfWeek | stream nextPutAll: (aDayOfWeek printString first: 2) ]
		separatedBy: [ stream space ]

printDayNumbers
	"While there are day numbers to print, prints them in a row"
	[self hasDayNumbersToPrint] whileTrue: [ self printDayNumbersRow ].

hasDayNumbersToPrint
	"If any of the group of 3 months currently printing has day numbers to print returns true, otherwise false"
	^currentMonths anySatisfy: [ :currentMonth | self isCurrentDateAtSameMonthOfYearAs: currentMonth ]

isCurrentDateAtSameMonthOfYearAs: currentMonth
	"Returns true if the date to print for currentMonth is actually for the currentMonth"
	^(self currentDateOf: currentMonth) month = currentMonth

printDayNumbersRow
	"For each month of the group of 3, prints a row of day numbers"
	currentMonths
		do: [ :currentMonth | self printDayNumbersRowOf: currentMonth ]
		separatedBy: [ stream space: 3 ].
	stream newLine

printDayNumbersRowOf: currentMonth
	"Prints the day numbers of the current week"
	(Sunday to: Saturday)
		do: [ :aDayOfWeek | self printDayNumberOf: currentMonth for: aDayOfWeek ]		
		separatedBy: [ stream space ]

printDayNumberOf: currentMonth for: aDayOfWeek
	"If the current date of the current month corresponds to aDayOfWeeks, prints its day number,
	if not, leaves a space
	This is important to leave the spaces in the first row and last row for those day of week
	that do not have a day number related"
	| currentDate |	
	currentDate := self currentDateOf: currentMonth.
	(self hasToPrint: currentDate of: currentMonth for: aDayOfWeek)
		ifTrue: [
			currentDate dayNumber printOn: stream length: 2 zeroPadded: false.
			self calculateNextCurrentDateOf: currentMonth ]
		ifFalse: [ stream space: 2 ]! !

hasToPrint: aDate of: aCurrentMonth for: aDayOfWeek		
	"Returns whether aDate is part of aCurrentMonth and its day of week is aDayOfWeek.
	It is used to decide whether to print the date day number or leave an space"
	^(aDate month = aCurrentMonth) and: [aDate day = aDayOfWeek]

currentDateOf: currentMonth		
	"Returns the date to print for currentMonth"
	^monthOfYearCurrentDate at: currentMonth number

calculateNextCurrentDateOf: currentMonth
	"Changes the date to print of the currentMonth to the next date"
	monthOfYearCurrentDate at: currentMonth number put: (self currentDateOf: currentMonth) next

center: stringToCenter in: aNumberOfCharacters
	"Prints stringToCenter centered in a line of aNumberOfCharacters total"
	| centerStart |	
	centerStart := aNumberOfCharacters - stringToCenter size // 2.
	stream
		space: centerStart;
		nextPutAll: stringToCenter;
		space: aNumberOfCharacters - centerStart - stringToCenter size

numberOfCharactersPerLine	
	"Returns the number of characters per line"
	^66

numberOfCharactersPerMonth	
	"Returns the number of character per month"
	^20
