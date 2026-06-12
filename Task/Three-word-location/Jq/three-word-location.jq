## Generic functions

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# From bitwise.jq
# integer to stream of 0s and 1s, least significant bit first
def bitwise:
  recurse( if . >= 2 then idivide(2) else empty end) | . % 2;

# inverse of `bitwise`
def stream_to_integer(stream):
  reduce stream as $c ( {power:1 , ans: 0};
      .ans += ($c * .power) | .power *= 2 )
    | .ans;

# Convert the $j least-significant bits of the input integer to an integer
def to_int($j):
  stream_to_integer(limit($j; bitwise));

# Take advantage of gojq's support for infinite-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Input is assumed to be a non-negative integer
def rightshift($n):
  reduce range(0;$n) as $i (.; idivide(2)) ;

def lpad($len; $fill):
  tostring
  | ($len - length) as $l
  | if $l <= 0 then .
    else ($fill * $l)[:$l] + .
    end;

## Functions to convert to and from the 'W00000' format
def toWord: "W\(lpad(5; "0"))";

def fromWord: .[1:] | tonumber;

# Latitude should be presented as a number in [-90, 90]
# and longitude as a number in [-180, 180].
def task($lat; $lon):
  # convert lat and lon to positive integers
  (($lat * 10000 | trunc) + 900000 ) as $ilat
  | (($lon * 10000 | trunc) + 1800000) as $ilon

  # build 43 bit integer comprising 21 bits (lat) and 22 bits (lon)
  | ($ilat * (2 | power(22)) + $ilon) as $latlon
  # isolate relevant bits
  | ($latlon | rightshift(28) | to_int(15) | toWord) as $w1
  | ($latlon | rightshift(14) | to_int(14) | toWord) as $w2
  | ($latlon | to_int(14) | toWord) as $w3
  | "Starting figures:",
    "  latitude = \($lat), longitude = \($lon)",
    "\nThree word location is:",
    ([$w1, $w2, $w3] | join(" ")),

     # now reverse the procedure
     ({}
      | .latlon = (  ($w1 | fromWord) * (2 | power(28))
                   + ($w2 | fromWord) * (2 | power(14))
                   + ($w3 | fromWord ) )
      | .ilat = (.latlon | rightshift(22))
      | .ilon = (.latlon | to_int(22))
      | .lat = ((.ilat - 900000) / 10000)
      | .lon = ((.ilon - 1800000) / 10000)
      | "\nAfter reversing the procedure:",
        "  latitude = \(.lat), longitude = \(.lon)" )
;

task(28.3852; -81.5638)
