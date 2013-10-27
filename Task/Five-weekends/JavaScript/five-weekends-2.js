var Months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
];

var leap = 0,
  // Relative offsets between first day of each month
  offset = [3,0,3,2,3,2,3,3,2,3,2,3],

  // Months that contain 31 days
  longMonths = [1,3,5,7,8,10,12],

  startYear = 1900,
  year = startYear,
  endYear = 2100,

  // Jan 1, 1900 starts on a Monday
  day = 1,

  totalPerYear = 0,
  total = 0,
  without = 0;

for (; year < endYear + 1; year++) {
  leap = totalPerYear = 0;

  if (year % 4 === 0) {
    if (year % 100 === 0) {
      if (year % 400 === 0) {
        leap = 1;
      }
    } else {
      leap = 1;
    }
  }

  for (var i = 0; i < offset.length; i++) {
    for (var j = 0; day === 5 && j < longMonths.length; j++) {
      if (i + 1 === longMonths[j]) {
        console.log(year + '-' + Months[i]);
        totalPerYear++;
        total++;
        break;
      }
    }

    // February -- if leap year, then +1 day
    if (i == 1) {
      day = (day + leap) % 7;
    } else {
      day = (day + offset[i]) % 7;
    }
  }

  if (totalPerYear === 0) {
    without++;
  }
}

console.log('Number of months that have five full weekends from 1900 to 2100: ' + total);
console.log('Number of years without any five full weekend months: ' + without);
