function startsOnFriday(month, year)
{
 // 0 is Sunday, 1 is Monday, ... 5 is Friday, 6 is Saturday
 return new Date(year, month, 1).getDay() === 5;
}
function has31Days(month, year)
{
 return new Date(year, month, 31).getDate() === 31;
}
function checkMonths(year)
{
 var month, count = 0;
 for (month = 0; month < 12; month += 1)
 {
  if (startsOnFriday(month, year) && has31Days(month, year))
  {
   count += 1;
   document.write(year + ' ' + month + '<br>');
  }
 }
 return count;
}
function fiveWeekends()
{
 var
  startYear = 1900,
  endYear = 2100,
  year,
  monthTotal = 0,
  yearsWithoutFiveWeekends = [],
  total = 0;
 for (year = startYear; year <= endYear; year += 1)
 {
  monthTotal = checkMonths(year);
  total += monthTotal;
  // extra credit
  if (monthTotal === 0)
   yearsWithoutFiveWeekends.push(year);
 }
 document.write('Total number of months: ' + total + '<br>');
 document.write('<br>');
 document.write(yearsWithoutFiveWeekends + '<br>');
 document.write('Years with no five-weekend months: ' + yearsWithoutFiveWeekends.length + '<br>');
}
fiveWeekends();
