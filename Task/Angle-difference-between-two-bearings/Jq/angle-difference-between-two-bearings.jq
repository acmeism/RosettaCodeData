# Angles are in degrees; the result is rounded to 4 decimal places:
def subtract($b1; $b2):
  10000 as $scale
  | (($scale * ($b2 - $b1)) % (360 * $scale)) | round / $scale
  | if   . < -180 then . + 360
    elif . >= 180 then . - 360
    else .
    end;

def pairs:
    [ 20,  45],
    [-45,  45],
    [-85,  90],
    [-95,  90],
    [-45, 125],
    [-45, 145],
    [ 29.4803, -88.6381],
    [-78.3251, -159.036],
    [-70099.74233810938, 29840.67437876723],
    [-165313.6666297357, 33693.9894517456],
    [1174.8380510598456, -154146.66490124757],
    [60175.77306795546, 42213.07192354373] ;

"Differences (to 4dp) between these bearings:",
( pairs as [$p0, $p1]
  | subtract($p0; $p1) as $diff
  | (if $p0 < 0 then " " else "  " end) as $offset
  | "\($offset)\($p0) and \($p1) -> \($diff)" )
