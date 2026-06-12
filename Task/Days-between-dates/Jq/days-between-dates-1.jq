def days_between(yyyymmddBefore; yyyymmddAfter):
  (yyyymmddBefore | strptime("%Y-%m-%d") | mktime) as $before
  | (yyyymmddAfter | strptime("%Y-%m-%d") | mktime) as $after
  # leap seconds are always inserted
  | (($after - $before) / (24*60*60) | floor) ;

def task:
  def prolog: "In the following, if the dates are not the same,",
  "the \"from\" date is included in the count of days, but the \"to\" date is not.\n",
  "If the first date is later than the second date, the count of days is negated.";

  def dates:
    ["1995-11-21", "1995-11-21"],
    ["2019-01-01", "2019-01-02"],
    ["2019-01-02", "2019-01-01"],
    ["2019-01-01", "2019-03-01"],
    ["2020-01-01", "2020-03-01"],
    ["1902-01-01", "1968-12-25"],
    ["2090-01-01", "2098-12-25"],
    ["1902-01-01", "2098-12-25"],
    ["1970-01-01", "2019-10-18"],
    ["2019-03-29", "2029-03-29"],
    ["2020-02-29", "2020-03-01"] ;

  prolog,
   (dates | "The number of days from \(.[0]) until \(.[1]) is \(days_between(.[0]; .[1] ))")
  ;

task
