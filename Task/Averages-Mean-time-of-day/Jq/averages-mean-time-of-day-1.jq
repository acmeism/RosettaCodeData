# input: array of "h:m:s"
def mean_time_of_day:
  def pi: 4 * (1|atan);
  def to_radians:   pi * . /(12*60*60);
  def from_radians: (. * 12*60*60) / pi;

  def secs2time:  # produce "hh:mm:ss" string
    def pad: tostring | (2 - length) * "0" + .;
    "\(./60/60 % 24 | pad):\(./60 % 60 | pad):\(. % 60 | pad)";

  def round:
    if . < 0 then -1 * ((- .) | round) | if . == -0 then 0 else . end
    else floor as $x
    | if (. - $x) < 0.5 then $x else $x+1 end
    end;

  map( split(":")
       | map(tonumber)
       | (.[0]*3600 + .[1]*60 + .[2])
       | to_radians )
   | (map(sin) | add) as $y
   | (map(cos) | add) as $x
   | if $x == 0 then (if $y > 3e-14 then pi/2 elif $y < -3e-14 then -(pi/2) else null end)
     else ($y / $x) | atan
     end
   | if . == null then null
     else from_radians
     | if (.<0) then . + (24*60*60) else . end
     | round
     | secs2time
     end ;
