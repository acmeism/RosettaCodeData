import times

proc daysBetween(date1, date2: string): int64 =
  const Fmt = initTimeFormat("yyyy-MM-dd")
  (date2.parse(Fmt, utc()) - date1.parse(Fmt, utc())).inDays

const Dates = [("1995-11-21","1995-11-21"),
               ("2019-01-01","2019-01-02"),
               ("2019-01-02","2019-01-01"),
               ("2019-01-01","2019-03-01"),
               ("2020-01-01","2020-03-01"),
               ("1902-01-01","1968-12-25"),
               ("2090-01-01","2098-12-25")]

for (date1, date2) in Dates:
  echo "Days between ", date1, " and ", date2, ": ", daysBetween(date1, date2)
