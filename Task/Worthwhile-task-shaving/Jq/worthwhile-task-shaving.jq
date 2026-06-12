### Formatting

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

def center($width):
  tostring
  | (($width-length)/2|floor) * " " + . | rpad($width);

### Task Shaving

def shaved: # time shaved off in seconds
  [1, 5, 30, 60, 300, 1800, 3600, 21600, 86400];

def columns:
  ["1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE", "5 MINUTES",
   "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY"];

def parameters:
  { diy: 365.25, minute: 60}
   | .hour = .minute * 60
   | .day = .hour * 24
   | .week = .day * 7
   | .month = .day * .diy / 12
   | .year = .day * .diy
   | .freq = [50 * .diy, 5 * .diy, .diy, .diy/7, 12, 1] # frequency per year
   | .mult = 5 # multiplier for table
;

# Total field width is 13
def fmtTime($interval):
  if . == 0 then 13*" "
  else floor
  | (if . == 1 then " " else "S" end) as $pl
  | "\(lpad(2)) \($interval + $pl | rpad(10))"
  end;

# Format one row
def row:
  map(lpad(13)) | "\(.[0]) | \(.[1:]|join(""))";

"*** HOW OFTEN YOU DO THE TASK ***" | center(90),
(["SHAVED OFF", "50/DAY", "5/DAY", "DAILY", "WEEKLY", "MONTHLY", "YEARLY"]
 | map(center(13)) | row),
("-" * 90),
(parameters as $p
 | range(0;9) as $y
 | [columns[$y],
    (range(0; 6) as $x
        | ($p.freq[$x] * shaved[$y] * $p.mult)
        | if   . < $p.minute   then .           | fmtTime("SECOND")
          elif . < $p.hour     then ./$p.minute | fmtTime("MINUTE")
          elif . < $p.day      then ./$p.hour   | fmtTime("HOUR")
          elif . < 14 * $p.day then ./$p.day    | fmtTime("DAY")
          elif . < 9 * $p.week then ./$p.week   | fmtTime("WEEK")
          elif . < $p.year     then ./$p.month  | fmtTime("MONTH")
          else 0 | fmtTime("")
          end) ] | row)
