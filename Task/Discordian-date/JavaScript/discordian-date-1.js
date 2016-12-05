/**
 * All Hail Discordia! - this script prints Discordian date using system date.
 * author: jklu, lang: JavaScript
 */
var seasons = ["Chaos", "Discord", "Confusion",
  "Bureaucracy", "The Aftermath"];
var weekday = ["Sweetmorn", "Boomtime", "Pungenday",
  "Prickle-Prickle", "Setting Orange"];

var apostle = ["Mungday", "Mojoday", "Syaday",
  "Zaraday", "Maladay"];

var holiday = ["Chaoflux", "Discoflux", "Confuflux",
  "Bureflux", "Afflux"];


Date.prototype.isLeapYear = function() {
  var year = this.getFullYear();
  if ((year & 3) !== 0) return false;
  return ((year % 100) !== 0 || (year % 400) === 0);
};

// Get Day of Year
Date.prototype.getDOY = function() {
  var dayCount = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  var mn = this.getMonth();
  var dn = this.getDate();
  var dayOfYear = dayCount[mn] + dn;
  if (mn > 1 && this.isLeapYear()) dayOfYear++;
  return dayOfYear;
};

function discordianDate(date) {
  var y = date.getFullYear();
  var yold = y + 1166;
  var dayOfYear = date.getDOY();

  if (date.isLeapYear()) {
    if (dayOfYear == 60)
      return "St. Tib's Day, in the YOLD " + yold;
    else if (dayOfYear > 60)
      dayOfYear--;
  }
  dayOfYear--;

  var divDay= Math.floor(dayOfYear/73);

  var seasonDay = (dayOfYear % 73) + 1;
  if (seasonDay == 5)
    return apostle[divDay] + ", in the YOLD " + yold;
  if (seasonDay == 50)
    return holiday[divDay] + ", in the YOLD " + yold;

  var season = seasons[divDay];
  var dayOfWeek = weekday[dayOfYear % 5];

  return dayOfWeek + ", day " + seasonDay + " of " +
    season + " in the YOLD " + yold;
}

function test(y, m, d, result) {
  console.assert((discordianDate(new Date(y, m, d)) == result), result);
}

console.log(discordianDate(new Date(Date.now())));
test(2010, 6, 22, "Pungenday, day 57 of Confusion in the YOLD 3176");
test(2012, 1, 28, "Prickle-Prickle, day 59 of Chaos in the YOLD 3178");
test(2012, 1, 29, "St. Tib's Day, in the YOLD 3178");
test(2012, 2, 1, "Setting Orange, day 60 of Chaos in the YOLD 3178");
test(2010, 0, 5, "Mungday, in the YOLD 3176");
test(2011, 4, 3, "Discoflux, in the YOLD 3177");
test(2015, 9, 19, "Boomtime, day 73 of Bureaucracy in the YOLD 3181");
