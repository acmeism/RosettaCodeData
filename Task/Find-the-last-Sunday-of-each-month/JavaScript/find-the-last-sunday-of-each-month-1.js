function lastSundayOfEachMonths(year) {
	var lastDay = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var sundays = [];
	var date, month;
	if (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) {
		lastDay[2] = 29;
	}
	for (date = new Date(), month = 0; month < 12; month += 1) {
		date.setFullYear(year, month, lastDay[month]);
		date.setDate(date.getDate() - date.getDay());
		sundays.push(date.toISOString().substring(0, 10));
	}
	return sundays;
}

console.log(lastSundayOfEachMonths(2013).join('\n'));
