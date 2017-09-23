five_weekends(1900;2101)
| "There are \(length) months with 5 weekends from 1900 to 2100 inclusive;",
  "the first and last five are as follows:",
  ( .[0: 5][] | pp),
  "...",
  ( .[length-5: ][] | pp),
  "In this period, there are \( [range(1900;2101)] - map( .[0] ) | length ) years which have no five-weekend months."
