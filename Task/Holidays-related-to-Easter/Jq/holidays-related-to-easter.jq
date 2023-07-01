def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# add the number of days to [year, month, day]
def addDays($days):
  . as [$y,$m,$d]
  | [$y,$m,$d + $days,0,0,0,0,0] | mktime | gmtime ;

# Output: [year, month_indexed_by_0, day]
def calculateEaster:
    . as $year
    | {}
    | .a = $year % 19
    | .b = (($year / 100)|floor)
    | .c = $year % 100
    | .d = ((.b / 4)|floor)
    | .e = .b % 4
    | .f = (((.b + 8) / 25)|floor)
    | .g = (((.b - .f + 1) / 3)|floor)
    | .h = (19 * .a + .b - .d - .g + 15) % 30
    | .i = ((.c / 4)|floor)
    | .k = .c % 4
    | .l = (32 + 2 * .e + 2 * .i - .h - .k) % 7
    | .m = (((.a + 11 * .h + 22 * .l) / 451)|floor)
    | .n = .h + .l - 7 * .m + 114
    | .month = ((.n / 31)|floor) # months indexed from 1
    | .day = (.n % 31) + 1
    | [$year, .month - 1, .day] ;

def holidayOffsets: [
    ["Easter", 0],
    ["Ascension", 39],
    ["Pentecost", 49],
    ["Trinity", 56],
    ["C/Christi", 60]
];

# Input: year
def outputHolidays:
  calculateEaster as $date
  | holidayOffsets[] as [$h, $o]
  | $date | addDays($o) | strftime("%d %b") ;

def tables:
  def row: "\(lpad(4))   \([outputHolidays] | join("   "))";

  "Year  Easter  Ascension Pentecost Trinity C/Christi",
  " CE   Sunday  Thursday   Sunday   Sunday  Thursday ",
  "----  ------  --------- --------- ------- ---------",
  ( range(400; 2101; 100) | row),
  "",
  ( range(2010; 2021) | row) ;

tables
