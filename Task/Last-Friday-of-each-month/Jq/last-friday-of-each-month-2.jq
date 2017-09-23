# year and month are numbered conventionally
def findLastFriday(year; month):
  def isLeapYear:
    year%4 == 0 and ( year%100!=0 or year%400==0 ) ;
  def days:
    if month == 2 then (if isLeapYear then 29 else 28 end)
    else [31, 28, 31,30,31,30,31,31,30,31,30,31][month-1]
    end;
  year as $year
  | month as $month
  | days
  | until( day_of_week($year; $month; .; null) == 6 ; .-1);

# input: year
def findLastFridays:
  def months:
    ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  . as $year
  | "YEAR: \(.)",
    (range(0;12) | "\(months[.]) \(findLastFriday($year; .+1))") ;

$year|tonumber|findLastFridays
