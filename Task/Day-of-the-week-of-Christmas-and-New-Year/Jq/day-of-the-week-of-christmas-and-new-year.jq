def weekdaynames:
  ["Sunday", "Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

# example: weekday(1999; 12; 25)
def weekday($year; $month; $day):
  "\($year)-\($month)-\($day)" | strptime("%Y-%m-%d") | weekdaynames[.[-2]];

1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393
| "In \(.), New year's day is on a \(weekday(.;1;1)), and Christmas day on \(weekday(.;12;25))."
