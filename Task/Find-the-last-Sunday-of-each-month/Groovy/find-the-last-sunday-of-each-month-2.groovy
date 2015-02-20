def ymd = { it.format('yyyy-MM-dd') }
def lastSundays = lastWeekDays.curry(Day.Sun)
lastSundays(args[0] as int).each { println (ymd(it)) }
