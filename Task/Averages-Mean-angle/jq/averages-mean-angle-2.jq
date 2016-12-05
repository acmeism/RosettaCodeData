# input: degrees
def mean_angle:
  def round:
    if . == null then null
    elif . < 0 then -1 * ((- .) | round) | if . == -0 then 0 else . end
    else ((. + 3e-14) | floor) as $x
    | if ($x - .) | abs < 3e-14 then $x else . end
    end;

  map( [1, deg2rad] | from_polar)
  | [ summation(.[0]), summation(.[1]) ]
  | to_polar
  | .[1]
  | rad2deg
  | round;
