// Month values start at 0, so 1 is for February
var isLeapYear = function (year) { return new Date(year, 1, 29).getDate() === 29; };
