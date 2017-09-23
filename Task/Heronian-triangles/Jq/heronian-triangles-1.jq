# input should be an array of the lengths of the sides
def hero:
  (add/2) as $s
  | ($s*($s - .[0])*($s - .[1])*($s - .[2])) as $a2
  | if $a2 > 0 then ($a2 | sqrt) else 0 end;

def is_heronian:
  hero as $h
  | $h > 0 and ($h|floor) == $h;

def gcd3(x; y; z):
  # subfunction expects [a,b] as input
  def rgcd:
    if .[1] == 0 then .[0]
    else [.[1], .[0] % .[1]] | rgcd
    end;
  [ ([x,y] | rgcd), z ] | rgcd;

def task(maxside):
  def rjust(width): tostring |  " " * (width - length) + .;

  [ range(1; maxside+1) as $c
    | range(1; $c+1) as $b
    | range(1; $b+1) as $a
    | if ($a + $b) > $c and gcd3($a; $b; $c) == 1
      then [$a,$b,$c] | if is_heronian then . else empty end
      else empty
      end ]

  # sort by increasing area, perimeter, then sides
  | sort_by( [ hero, add, .[2] ] )
  | "The number of primitive Heronian triangles with sides up to \(maxside): \(length)",
    "The first ten when ordered by increasing area, then perimeter, then maximum sides:",
    "      perimeter area",
    (.[0:10][] | "\(rjust(11)) \(add | rjust(3)) \(hero | rjust(4))" ),
    "All those with area 210, ordered as previously:",
    "      perimeter area",
    ( .[] | select( hero == 210 ) | "\(rjust(11)) \(add|rjust(3)) \(hero|rjust(4))" ) ;

task(200)
