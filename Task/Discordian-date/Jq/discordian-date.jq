### Gregorian calendar
def isLeapYear(y):
   y%4 == 0 and ((y%100 != 0) or (y%400 == 0));

### Discordian calendar
def seasons:  ["Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"];

def weekdays: ["Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"];

def apostles: ["Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"];

def holidays: ["Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"];

# Input: {year, dayOfYear}
def discordian(date):
  date.year as $y
  | " in the YOLD \($y + 1166)." as $yold
  | { doy: date.dayOfYear, holyday: ""}
  | if isLeapYear($y) and (.doy == 60) then "St. Tib's Day" + $yold
    else if isLeapYear($y) and (.doy > 60) then .doy += -1 else . end
    | .doy += -1
    | .seasonDay = ((.doy % 73) + 1)
    | .seasonNr = ((.doy/73)|floor)
    | .weekdayNr = .doy % 5
    | if .seasonDay == 5 then .holyday = " Celebrate \(apostles[.seasonNr])!"
      elif .seasonDay == 50 then .holyday = " Celebrate \(holidays[.seasonNr])!"
      else .
      end
    | .season = seasons[.seasonNr]
    | .dow = weekdays[.weekdayNr]
    | "\(.dow), day \(.seasonDay) of \(.season)\($yold)\(.holyday)"
    end ;

def dates: [
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
];

dates[]
| (strptime("%Y-%m-%d")
   | {year: .[0], dayOfYear: (1 + .[-1])}) as $dt
| "\(.) = \(discordian($dt))"
