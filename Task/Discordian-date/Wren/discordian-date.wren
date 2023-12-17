import "./date" for Date
import "./fmt" for Fmt

var seasons  = ["Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"]
var weekdays = ["Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"]
var apostles = ["Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"]
var holidays = ["Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"]

var discordian = Fn.new { |date|
    var y = date.year
    var yold = " in the YOLD %(y + 1166)."
    var doy = date.dayOfYear
    if (Date.isLeapYear(y)) {
        if (doy == 60) return "St. Tib's Day" + yold
        if (doy > 60) doy = doy - 1
    }
    doy = doy - 1
    var seasonDay = doy % 73 + 1
    var seasonNr = (doy/73).floor
    var weekdayNr = doy % 5
    var holyday = ""
    if (seasonDay == 5)  holyday = " Celebrate %(apostles[seasonNr])!"
    if (seasonDay == 50) holyday = " Celebrate %(holidays[seasonNr])!"
    var season = seasons[seasonNr]
    var dow = weekdays[weekdayNr]
    return Fmt.swrite("$s, day $s of $s$s$s", dow, seasonDay, season, yold, holyday)
}

var dates = [
   "2010-01-01",
   "2010-01-05",
   "2011-02-19",
   "2012-02-28",
   "2012-02-29",
   "2012-03-01",
   "2013-03-19",
   "2014-05-03",
   "2015-05-31",
   "2016-06-22",
   "2016-07-15",
   "2017-08-12",
   "2018-09-19",
   "2018-09-26",
   "2019-10-24",
   "2020-12-08",
   "2020-12-31"
]

for (date in dates) {
    var dt = Date.parse(date)
    System.print("%(date) = %(discordian.call(dt))")
}
