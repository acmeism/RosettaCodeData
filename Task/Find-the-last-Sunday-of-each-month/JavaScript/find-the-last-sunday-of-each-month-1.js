function lastSundayOfEachMonths(year) {
	var lastDay = [31,28,31,30,31,30,31,31,30,31,30,31]
	if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) lastDay[2] = 29
	for (var date = new Date(), month=0; month<12; month+=1) {
		date.setFullYear(year, month, lastDay[month])
		date.setDate(date.getDate()-date.getDay())
		document.write(date.toISOString().substring(0,10), '<br>')
	}
}
	
lastSundayOfEachMonths(2013)
