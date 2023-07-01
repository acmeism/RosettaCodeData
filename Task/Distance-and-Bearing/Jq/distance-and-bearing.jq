def pi: 1|atan * 4;

# Read a TSV file one line at a time,
# and emit a stream of arrays, one array per line:
def readTSV: [inputs | sub("  *$";"") / "\t" ];

def airports:
  [readTSV
   |    {airportID: (.[0] | tonumber),
         name      : .[1],
         city      : .[2],
         country   : .[3],
         iata      : .[4],
         icao      : .[5],
         latitude  : (.[6] | tonumber),
         longitude : (.[7] | tonumber),
         altitude  : (.[8] | tonumber),
         timezone  : .[9],
         dst       : .[10],
         tzOlson   : .[11],
         type      : .[12],
         source    : .[13]} ];

def calculateDistance(lat1; lon1; lat2; lon2; units):
  if (lat1 == lat2 and lon1 == lon2) then 0
  else pi as $pi
  | ($pi * lat1 / 180) as $radlat1
  | ($pi * lat2 / 180) as $radlat2
  | (lon1 - lon2) as $theta
  | ($pi * $theta / 180) as $radtheta
  | {}
  | .dist = ($radlat1|sin) * ($radlat2|sin) +
            ($radlat1|cos) * ($radlat2|cos) * ($radtheta|cos)
  | if .dist > 1 then .dist = 1 else . end
  | .dist |= (acos * 180 / $pi) * 60 * 1.1515576  # distance in statute miles
  | if   (units == "K") then .dist *= 1.609344          # distance in kilometers
    elif (units == "N") then .dist *= 0.868976          # distance in nautical miles
    else .
    end
  | .dist
  end ;

def calculateBearing(lat1; lon1; lat2; lon2):
  if (lat1 == lat2 and lon1 == lon2) then 0
  else pi as $pi
  | ($pi * lat1 / 180) as $radlat1
  | ($pi * lat2 / 180) as $radlat2
  | ($pi * (lon2 - lon1) / 180) as $raddlon
  | ( ($raddlon|sin) * ($radlat2|cos) ) as $y
  | (($radlat1|cos) * ($radlat2|sin) -
     ($radlat1|sin) * ($radlat2|cos) * ($raddlon|cos)) as $x
  | ((atan2($y;$x) * 180 / $pi) + 360) % 360
  end;

# request from airplane at position $X; $Y
def request($X; $Y):
  airports as $airports
  | reduce $airports[] as $a ([];
        ((calculateDistance($X; $Y; $a.latitude; $a.longitude; "N") * 10 | round)
         / 10) as $dist
      | (calculateBearing($X; $Y; $a.latitude; $a.longitude)|round ) as $bear
      | . + [ [$a.name, $a.country, $a.icao, $dist, $bear] ] ) ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def fmt:
  def l($n): lpad($n);
  "\(.[0] |l(36)) | \(.[1]|l(14)) | \(.[2]|l(4)) |\(.[3]|l(15)) |\(.[4]|l(10))";

# Example:
def display($n):
  "Closest \($n) destinations relative to position \(.[0]), \(.[1]):",
  "",
  "                Name                 |    Country     | ICAO | Distance in NM | Bearing in ° ",
  "-------------------------------------+----------------+------+----------------+--------------",
  (request(.[0]; .[1])
   | sort_by( .[3] )
   | .[0:$n][] | fmt ) ;


[51.514669, 2.198581] | display(20)

''Invocation'': jq -nrRf distance-and-bearing.jq airports.tsv
