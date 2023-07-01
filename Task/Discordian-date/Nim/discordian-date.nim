import times, strformat

const

  DiscordianOrigin = -1166
  SaintTibsDay = "St. Tib’s Day"

type

  Season = enum
    sCha = (1, "Chaos"), sDis = "Discord", sCon = "Confusion",
    sBur = "Bureaucracy", sAft = "The Aftermath"

  ErisianWeekDay = enum
    eSwe = "Sweetmorn", eBoo = "Boomtime", ePun = "Pungenday",
    ePri = "Prickle-Prickle", eSet = "Setting Orange"

  SeasonDayRange = range[1..73]

  # Description of a discordian date.
  DiscordianDate = object
    year: int
    yearday: YeardayRange
    case isSaintTibsDay: bool
    of false:
      seasondayZero: int
      seasonZero: int
      weekday: ErisianWeekDay
    else:
      nil

#---------------------------------------------------------------------------------------------------

proc toDiscordianDate(gdate: DateTime): DiscordianDate =
  ## Convert a DateTime to a discordian date.
  ## All the time fields are ignored.

  # Create the object.
  result = DiscordianDate(isSaintTibsDay: gdate.isLeapDay)

  # The yearday field is unchanged.
  result.yearday = gdate.yearday

  # The year is simply translated.
  result.year = gdate.year - DiscordianOrigin

  # For remaining fields, we must take in account leap years.
  if not result.isSaintTibsDay:
    var yearday = result.yearday
    if gdate.year.isLeapYear and result.yearday > 59:
      dec yearday
    # Now, we have simply to use division and modulo using the corrected yearday.
    result.seasonZero = yearday div SeasonDayRange.high
    result.seasondayZero = yearday mod SeasonDayRange.high
    result.weekday = ErisianWeekDay(yearday mod 5)

#---------------------------------------------------------------------------------------------------

proc `$`(date: DiscordianDate): string =
  ## Convert a discordian date to a string.
  if date.isSaintTibsDay:
    result = SaintTibsDay
  else:
    result = fmt"{date.weekday}, {Season(date.seasonZero + 1)} {date.seasondayZero + 1}"
  result &= fmt", {date.year} YOLD"

#---------------------------------------------------------------------------------------------------

proc showDiscordianDate(year, month, day: Natural) =
  ## Show the discordian date corresponding to a gregorian date.
  let gdate = initDateTime(year = year, month = Month(month), monthday = day,
                           hour = 0, minute = 0, second = 0)
  echo gdate.format("YYYY-MM-dd"), ": ", $gdate.toDiscordianDate()

#———————————————————————————————————————————————————————————————————————————————————————————————————

showDiscordianDate(2100, 12, 31)
showDiscordianDate(2012, 02, 28)
showDiscordianDate(2012, 02, 29)
showDiscordianDate(2012, 03, 01)
showDiscordianDate(2010, 07, 22)
showDiscordianDate(2012, 09, 02)
showDiscordianDate(2012, 12, 31)
