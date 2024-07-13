include "Date" {search: "."};

### Generic functions

def assertEq($p;$q):
  if $p == $q
  then .
  else debug("assertion violation: \($p) != \($q)") as $debug | .
  end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def trim: sub("^ *";"") | sub(" *$";"");

# Input: string such as "12 Mar 2012"
# Output: Date
def parseDayMonthYear:
  def months:
    {Jan:1, Feb:2, Mar:3, Apr: 4, May: 5, Jun: 6,
     Jul:7, Aug:8, Sep:9, Oct:10, Nov:11, Dec:12};
  capture("(?<day>[0-9]+) *(?<month>[A-Za-z]+) *(?<year>[0-9]+)")
  | .month |= months[ .[:3] ]
  | map_values(tonumber)
  | {year, month, day};

### French Republican Calendar (FRC)

def introductionDate: Date(1792; 9; 22);

# Use the 'continuous method' for years after 1805
def isLeapYearFRC:
  (. + 1)
  | (. % 4 == 0) and ((. % 100 != 0) or (. % 400 == 0));

# If the numbers $year, $month, and $day specify a valid date
# in the French Republican Calendar, then emit {$year, $month, $day};
# otherwise generate an informative error message.
def FrenchRCDate($year; $month; $day):
  def err(msg): "Invalid date (\(msg)): FrenchRCDate(\($year); \($month); \($day))" | error;
  if ($year <= 0 or $month < 1 or $month > 13) then err(if $year <= 0 then "year" else "month" end) end
  | if $month < 13
    then if $day < 1 or $day > 30 then err("day") end
    else ($year | isLeapYearFRC) as $leap
    | if $leap and ($day < 1 or $day > 6) then err("invalid day in leap year") end
    | if ($leap|not) and ($day < 1 or $day > 5) then err("invalid day in non-leap year") end
    end
  | {$year, $month, $day};

# for convenience we treat 'Sansculottide' as an extra month with 5 or 6 days
def months:
  ["Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse", "Germinal",
   "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide"] ;

def intercal:
  ["Fête de la vertu", "Fête du génie", "Fête du travail",
   "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"];

# Input: a string specifying a FRC date
def parse:
  . as $frcDate
  | (trim|split(" ")) as $splits
  | if $splits|length == 3
    then (months | index($splits[1]) + 1) as $month
    | if $month < 1 or $month > 13 then "Invalid month." | error end
    | ($splits[2]|tonumber) as $year
    | if $year < 1 then "Invalid year." | error end
    | (if ($month < 13) then 30 elif $year|isLeapYearFRC then 6 else 5 end) as $monthLength
    | ($splits[0] | tonumber) as $day
    |  if $day < 1 or $day > $monthLength then "Invalid day." | error end
    | FrenchRCDate($year; $month; $day)

    elif ($splits|length | IN(4,5))
    then $splits[-1] as $yearStr
    | ($yearStr|tonumber) as $year
    | if $year < 1 then "Invalid year." | error end
    | ($frcDate | trim[0: -($yearStr|length + 1)] ) as $scDay
    | (intercal | index($scDay) + 1) as $day
    | (if $year | isLeapYearFRC then 6 else 5 end) as $maxDay
    | if $day < 1 or $day > $maxDay then "Invalid day." | error end
    | FrenchRCDate($year; 13; $day)
    else "Invalid French Republican date." | error
    end
;

# Input: Date (Gregorian)
# Output:
def fromLocalDate:
  # $start and $finish should be two Date objects
  def daysFrom($start; $finish):
    ($finish|daysBeforeDate) - ($start|daysBeforeDate);

  (daysFrom(introductionDate; .) + 1) as $daysDiff
  | if ($daysDiff <= 0) then "Date can't be before 22 September 1792." | error end
  | {year: 1, startDay: 1}
  | until(.done;
      (.startDay + (if .year|isLeapYearFRC then 365 else 364 end)) as $endDay
      | if ($daysDiff >= .startDay and $daysDiff <= $endDay) then .done = true
        else .year += 1
        | .startDay = $endDay + 1
        end )
  | ($daysDiff - .startDay) as $remDays
  | (($remDays / 30)|floor) as $month
  | ($remDays - $month * 30) as $day
  | FrenchRCDate(.year; $month + 1; $day + 1)
;

# Input: an FRC Date
def toString:
  if .month < 13 then "\(.day) \(months[.month - 1]) \(.year)"
  else "\(intercal[.day - 1]) \(.year)"
  end;

# Input: an FRC Date
def toLocalDate:
  (reduce range(1; .year) as $i (0; . + (if $i|isLeapYearFRC then 366 else 365 end))) as $sumDays
  | ((.month - 1) * 30 + .day - 1) as $dayInYear
  | introductionDate | addDays($sumDays + $dayInYear) ;


### Examples

def dates: [
     "22 September 1792", "20 May 1795", "15 July 1799", "23 September 1803",
     "31 December 1805", "18 March 1871", "25 August 1944", "19 September 2016",
     "22 September 2017", "28 September 2017"
];

def task:
  def format:
    "\(.day) \(monthNames[.month]) \(.year)";

  dates as $dates
  | reduce range(0; $dates|length) as $i ({};
      .date = $dates[$i]
      | .thisDate = (.date|parseDayMonthYear)
      | .frcd = (.thisDate|fromLocalDate)
      | .frcDates[$i] = (.frcd|toString)
      | .emit += "\(.date|lpad(26)) => \(.frcDates[$i])\n")
  | .emit,

  # now process the other way around
  range(0; $dates|length) as $i
  | .frcDates[$i] as $frcDate
  | ($frcDate|parse|toLocalDate|format) as $lds
  | assertEq($dates[$i]; $lds)
  | "\($frcDate|lpad(26)) => \($lds)"
;

task
