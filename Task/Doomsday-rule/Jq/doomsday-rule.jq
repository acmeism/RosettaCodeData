def weekdaynames: ["Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

# For months 1 through 12, the date of the first doomsday that month.
def leapyear_firstdoomsdays: [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];
def nonleapyear_firstdoomsdays: [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];

# get_weekday(year::Int; month::Int; day::Int)::String
# Return the weekday of a given date in the past or future subject to 1582<=$year<=9999.
# Uses Conway's doomsday rule (see also https://en.wikipedia.org/wiki/Doomsday_rule)

def assert(exp; msg):
  if env.JQ_ASSERT then
    (exp as $e | if $e then . else . as $in | "assertion violation: \(msg) => \($e)" | error end)
  else . end;

def get_weekday($year; $month; $day):
    # sanity checks
      assert(1582 <= $year and $year <= 9999; "Invalid year (\($year) - should be after 1581 and 4 digits)")
    | assert( 1 <= $month and $month <= 12;   "Invalid month, should be between 1 and 12")
    | assert( 1 <= $day and $day <= 31;       "Invalid day, should be between 1 and 31")

    # Conway's doomsday algorithm
    | ((2 + 5 * ($year % 4) + 4 * ($year % 100) + 6 * ($year % 400)) % 7) as $doomsday
    # leap year determination:
    | (if (($year % 4 != 0) or ($year % 100 == 0 and $year % 400 != 0))
      then nonleapyear_firstdoomsdays[$month - 1]
      else leapyear_firstdoomsdays[$month - 1]
      end) as $anchorday
   | (($doomsday + $day - $anchorday + 7) % 7) as $weekday # IO==0
   | weekdaynames[$weekday] ;

("January 6, 1800 was on a "      + get_weekday(1800;  1;  6)),
("March 29, 1875 was on a "       + get_weekday(1875;  3; 29)),
("December 7, 1915 was on a "     + get_weekday(1915; 12;  7)),
("December 23, 1970 was on a "    + get_weekday(1970; 12; 23)),
("May 14, 2043 will be on a "     + get_weekday(2043;  5; 14)),
("February 12, 2077 will be on a "+ get_weekday(2077;  2; 12)),
("April 2, 2101 will be on a "    + get_weekday(2101;  4;  2)),
("April 2, 21011 will be on a "   + get_weekday(21011; 4;  2))
