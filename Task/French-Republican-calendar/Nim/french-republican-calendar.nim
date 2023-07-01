import strformat, strscans, strutils, times

const

  RcMonths = ["Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse",
              "Germinal", "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor"]

  SansCulottides = ["Fête de la vertu", "Fête du génie", "Fête du travail",
                    "Fête de l’opinion", "Fête des récompenses", "Fête de la Révolution"]

let
  # First and last dates of republican calendar expressed in gregorian calendar.
  FirstRcDate = initDateTime(22, mSep, 1792, 0, 0, 0)
  LastRcDate = initDateTime(31, mDec, 1805, 0, 0, 0)

type
  # French republican date representation.
  RcDayRange = 1..30
  RcMonthRange = 1..13
  RcYearRange = 1..14
  RepublicanDate = tuple[year: RcYearRange, month: RcMonthRange, day: RcDayRange]

# Last dates of republican calendar expressed in republican calendar.
const RcLastDate: RepublicanDate = (RcYearRange(14), RcMonthRange(4), RcDayRange(10))


proc notnum(input: string; str: var string; start: int): int =
  # Parsing procedure to extract non numerical part of a date.
  var i = start
  while i <= input.high:
    if input[i] in '0'..'9': break
    str.add input[i]
    inc i
  if str.len == 0 or str[^1] != ' ': return -1   # Not terminated by a space.
  str.setLen(str.len - 1)   # Back before the space.
  result = str.len


proc parseRepublicanDate(rdate: string): RepublicanDate =
  ## Parse a French republican date and return its representation.

  let date = rdate.strip()
  var day, month, year: int
  var monthString, dayString: string

  if date.scanf("$i $+ $i", day, monthString, year):
    # Normal day.
    if day notin 1..30:
      raise newException(ValueError, "wrong day number: $1.".format(day))
    month = RcMonths.find(monthString) + 1
    if month == 0:
      raise newException(ValueError, "unknown French republican month: $1." % monthString)

  elif date.scanf("${notnum} $i", dayString, year):
    # Sans-culottide day (also known as “jour complémentaire”).
    month = 13  # Value used for sans-culottide days.
    day = SansCulottides.find(dayString) + 1
    if day == 0:
      raise newException(ValueError, "wrong “sans-culottide” day: « $1 »." % dayString)
    if day == 6 and year mod 4 != 3:
      raise newException(ValueError, "republican year $1 is not a leap year".format(year))

  else:
    raise newException(ValueError, "invalid French republican date: « $1 »." % date)

  result = (RcYearRange(year), RcMonthRange(month), RcDayRange(day))
  if result > RcLastDate:
    raise newException(ValueError, "republican date out of range: « $1 »." % date)


proc `$`(date: RepublicanDate): string =
  ## Return the string representation of a French republican date.

  if date.month != 13:
    # Normal day.
    result = "$1 $2 $3".format(date.day, RcMonths[date.month - 1], date.year)
  else:
    # Supplementary day.
    result = "$1 $2".format(SansCulottides[date.day - 1], date.year)


proc toGregorian(rdate: RepublicanDate): DateTime =
  ## Convert a republican date tuple to a gregorian date (DateTime object).
  let day = (rdate.day - 1) + (rdate.month - 1) * 30 + (rdate.year - 1) * 365 + rdate.year div 4
  result = FirstRcDate + initTimeInterval(days = day)


proc toGregorian(rdate: string): string =
  ## Convert a republican date string to a gregorian date string.
  let date = rdate.parseRepublicanDate()
  result = date.toGregorian().format("dd MMMM yyyy")


proc toRepublican(gdate: DateTime): RepublicanDate =
  ## Convert a gregorian date (DateTime object) to a republican date tuple.

  if gdate notin FirstRcDate..LastRcDate:
    raise newException(ValueError, "impossible conversion to republican date.")
  let d = gdate - FirstRcDate

  # Add a dummy year before year 1 in order to use a four years period.
  let dayNumber = d.inDays + 365
  let periodNum = dayNumber div 1461
  let dayInPeriod = dayNumber mod 1461

  # Compute year and day in year.
  let yearInPeriod = min(dayInPeriod div 365, 3)
  result.year = periodNum * 4 + yearInPeriod
  let dayInYear = dayInPeriod - yearInPeriod * 365

  # Compute month and day.
  result.month = dayInYear div 30 + 1
  result.day = dayInYear mod 30 + 1


proc toRepublican(gdate: string): string =
  ## Convert a gregorian date string to a republican date string.
  let date = gdate.parse("d MMMM yyyy")
  result = $(date.toRepublican())


when isMainModule:

  const
    RepublicanDates = ["1 Vendémiaire 1", "1 Prairial 3", "27 Messidor 7",
                      "Fête de la Révolution 11", "10 Nivôse 14"]
    GregorianDates = ["22 September 1792", "20 May 1795", "15 July 1799",
                      "23 September 1803", "31 December 1805"]

  echo "From French republican dates to gregorian dates:"
  for rdate in RepublicanDates:
    echo &"{rdate:>24} → {rdate.toGregorian()}"
  echo()

  echo "From gregorian dates to French republican dates:"
  for gdate in GregorianDates:
    echo &"{gdate:>24} → {gdate.toRepublican()}"
