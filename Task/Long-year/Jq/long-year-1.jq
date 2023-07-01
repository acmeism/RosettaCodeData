# Use Zeller's Congruence to determine the day of the week, given
# year, month and day as integers in the conventional way.
# Emit 0 for Saturday, 1 for Sunday, etc.
#
def day_of_week($year; $month; $day):
  if $month == 1 or $month == 2 then
    [$month + 12, $year - 1]
  else
    [$month, $year]
  end
  | $day + (13*(.[0] + 1)/5|floor)
    +  (.[1]%100)       + ((.[1]%100)/4|floor)
    +  (.[1]/400|floor) - 2*(.[1]/100|floor)
  | . % 7 ;

def has53weeks:
  day_of_week(.; 1; 1) == 5 or day_of_week(.; 12; 31) == 5;

# To display results neatly:
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

"Long years from 1900 to 2100 inclusive:",
([range(1900;2101) | select(has53weeks)] | nwise(10) | join(", "))
