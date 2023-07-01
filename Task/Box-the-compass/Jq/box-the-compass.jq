# Input: the input heading given as a number in degrees.
# Output: the corresponding integer index (from 0 to 31 inclusive)
# into the table, compassPoint, of compass point names.
def cpx:
  (((. / 11.25) + 0.5)|floor % 32)
  | if . < 0 then . + 32
    else .
    end;

# Compass point names
def compassPoint: [
    "North",
    "North by east",
    "North-northeast",
    "Northeast by north",
    "Northeast",
    "Northeast by east",
    "East-northeast",
    "East by north",
    "East",
    "East by south",
    "East-southeast",
    "Southeast by east",
    "Southeast",
    "Southeast by south",
    "South-southeast",
    "South by east",
    "South",
    "South by west",
    "South-southwest",
    "Southwest by south",
    "Southwest",
    "Southwest by west",
    "West-southwest",
    "West by south",
    "West",
    "West by north",
    "West-northwest",
    "Northwest by west",
    "Northwest",
    "Northwest by north",
    "North-northwest",
    "North by west"
];

### The task
# Input: heading in degrees
def degreesToCompassPoint:
  compassPoint[cpx];

def r: [
    0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5,
    84.37, 84.38, 101.25, 118.12, 118.13, 135.0, 151.87, 151.88, 168.75,
    185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13, 270.0,
    286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, 354.38
];

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

"Index  Compass point        Heading",
(r as $r
 | range(0; $r|length)
 | $r[.] as $h
 | ((.%32) + 1) as $index                  # index as per requirements
 | ($h | degreesToCompassPoint) as $d
 | "\($index|lpad(3)) \($d|lpad(20))   \($h)°"
)
