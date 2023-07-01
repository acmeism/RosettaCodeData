def weekdaynames: ["Su", "Mo","Tu", "We", "Th", "Fr", "Sa"];

# q.v. weekday
# Output the integer index of weekdaynames, i.e. Sunday is 0
def dayofweek($year; $month; $day):
  "\($year)-\($month)-\($day)" | strptime("%Y-%m-%d") | .[-2];

def isLeapYear(y):
   y%4 == 0 and ((y%100 != 0) or (y%400 == 0));

# January is 1
def monthLength($y; $m):
  def __diy: [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
  def __diy2: [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

  if isLeapYear($y)
  then __diy2[$m] - __diy2[$m-1]
  else __diy[$m] - __diy[$m-1]
  end;

def calendar(year):
  def snoopy: "🐶";
  def months: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December" ];
  (weekdaynames | join(" ")) as $days
  # $chunk is a list of three months in group number $c
  | def printRow($chunk; $c):
    # The line of month names:
    (" " + ($chunk | map(center(20)) | join("     "))),
    # The line of weekday names
    (" " + ([range(0;3)| $days] | join("     "))),
    # The body of the calendar
    (   [ dayofweek(year; $c*3 + 1; 1),
          dayofweek(year; $c*3 + 2; 1),
          dayofweek(year; $c*3 + 3; 1)] as $first
      | [ monthLength(year; $c*3 + 1),
          monthLength(year; $c*3 + 2),
          monthLength(year; $c*3 + 3) ] as $mlen
      # Print up to 6 lines
      | range(0;6) as $i
      | reduce range(0;3) as $j ("";
            (1 + (7 * $i) - $first[$j]) as $start
            | (reduce range($start; $start+7) as $k (.;
                   if ($k >= 1 and $k <= $mlen[$j])
                   then . + ($k|lpad(3))
                   else . + "   "
                   end )  +  "    " ) )
        ),
	"";

    (snoopy, "--- \(year) ---" | center(72)),
    ( [months|nwise(3)] as $chunks
      | range(0;3) | printRow( $chunks[.]; .) );

calendar(1969)
