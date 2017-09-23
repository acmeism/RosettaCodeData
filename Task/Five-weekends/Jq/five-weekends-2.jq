def weekday_of_last_day_of_month(year; month):
  def day_before(day): (6+day) % 7;

  if month==12 then day_before( day_of_week(year+1; 1; 1) )
  else day_before( day_of_week( year; month+1; 1 ) )
  end
;

# The only case where the month has 5 weekends is when the last day
# of the month falls on a Sunday and the month has 31 days.
#
def five_weekends(from; to):
  reduce range(from; to) as $year
    ([]; reduce (1,3,5,7,8,10,12) as $month  # months with 31 days
      (.;
       weekday_of_last_day_of_month($year; $month) as $day
       | if $day == 1 then . + [[ $year, $month]] else . end ))
;

# Input [year, month] as conventional integers; print e.g. "Jan 2001"
def pp:
  def month:
    ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][.-1];
   "\(.[1] | month) \(.[0])"
;
