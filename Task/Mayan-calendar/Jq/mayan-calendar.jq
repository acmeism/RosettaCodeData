### General utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
def rpad($len): tostring | ($len - length) as $l | . + (" " * $l);

# days_between("2020-01-01"; "2020-01-02") #=> 1
# days_between("2020-01-02"; "2020-01-01") #=> -1
def days_between($yyyymmddBefore; $yyyymmddAfter):
  (yyyymmddBefore | strptime("%Y-%m-%d") | mktime) as $before
  | (yyyymmddAfter | strptime("%Y-%m-%d") | mktime) as $after
  # leap seconds are always inserted
  | (($after - $before) / (24*60*60) | floor) ;

### `Date` objects

def Date($year; $month; $day): {$year, $month, $day};

# Convert a Date object to a string yyyy-mm-dd
# Other inputs are (currently) unscathed.
def yyyymmdd:
  if type == "object" then "\(.year)-\(.month)-\(.day)"
  else .
  end;

### Mayan Calendar

def sacred:
  "Imix’ Ik’ Ak’bal K’an Chikchan Kimi Manik’ Lamat Muluk Ok Chuwen Eb Ben Hix Men K’ib’ Kaban Etz’nab’ Kawak Ajaw"
  | split(" ");

def civil:
  "Pop Wo’ Sip Sotz’ Sek Xul Yaxk’in Mol Ch’en Yax Sak’ Keh Mak K’ank’in Muwan’ Pax K’ayab Kumk’u Wayeb’"
  | split(" ");

def CREATION_TZOLKIN: "2012-12-21";

# Input: Date or yyyy-mm-dd
def tzolkin:
  (days_between(CREATION_TZOLKIN; yyyymmdd)) as $diff
  | {rem: ($diff % 13)}
  | if .rem < 0 then .rem += 13 end
  | .num = (if .rem <= 9 then .rem + 4 else .rem - 9 end)
  | .rem = $diff % 20
  | if .rem <= 0 then .rem += 20 end
  | [.num, sacred[.rem-1] ] ;

# Input: Date or yyyy-mm-dd
def haab:
  def ZERO_HAAB: "2019-04-02";
  (days_between(ZERO_HAAB; yyyymmdd)) as $diff
  | {rem: ($diff % 365)}
  | if .rem < 0 then .rem += 365 end
  | .month = civil[((.rem+1)/20)|floor]
  | .last = (if .month == "Wayeb'" then 5 else 20 end)
  | .d = .rem%20 + 1
  | if .d < .last then [(.d|tostring), .month]
    else ["Chum", .month]
    end;

# Input: Date or yyyy-mm-dd
def longCount:
  {diff: days_between(CREATION_TZOLKIN; yyyymmdd)}
   | .diff  += 13*400*360
   | .baktun = ((.diff/(400*360)) | floor)
   | .diff   = .diff % (400*360)
   | .katun  = ((.diff/(20 * 360))|floor)
   | .diff   = .diff % (20*360)
   | .tun    = ((.diff/360)|floor)
   | .diff   = .diff % 360
   | .winal  = ((.diff/20)|floor)
   | .kin    = .diff % 20
   |  [.baktun, .katun, .tun, .winal, .kin]
   | join(".");

# Input: Date or yyyy-mm-dd
def lord:
  {diff: days_between(CREATION_TZOLKIN; yyyymmdd)}
  | .rem = .diff % 9
  | if .rem <= 0 then .rem += 9 end
  | "G\(.rem)";


def dates: [
    "1961-10-06",
    "1963-11-21",
    "2004-06-19",
    "2012-12-18",
    "2012-12-21",
    "2019-01-19",
    "2019-03-27",
    "2020-02-29",
    "2020-03-01",
    "2071-05-16"
];

" Gregorian   Tzolk’in        Haab’              Long           Lord of",
"   Date       # Name       Day Month            Count         the Night",
"----------   --------    -------------        --------------  ---------",
# Date.default = Date.isoDate
(dates[]
 | tzolkin as [$n, $s]
 | haab as [$d, $m]
 | [., ($n | lpad(4)), ($s | rpad(8)),  ($d|lpad(4)), ($m|rpad(8)), (longCount|lpad(20)), (lord|lpad(6))]
 | join(" ")
)
