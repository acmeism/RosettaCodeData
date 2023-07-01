# Use jq's mktime and gmtime to produce the day of week,
# with 0 for Sunday, 1 for Monday, etc
# $year $month $day are conventional
def day_of_week_per_gmtime($year; $month; $day):
   [$year, $month - 1, $day, 0, 0, 1, 0, 0] | mktime | gmtime | .[-2];

# 4 corresponds to Thursday
def has53weeks:
  day_of_week_per_gmtime(.; 1; 1) == 4 or day_of_week(.; 12; 31) == 4;

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

"Long years from 1900 to 2100 inclusive:",
([range(1900;2101) | select(has53weeks)] | nwise(10) | join(", "))
