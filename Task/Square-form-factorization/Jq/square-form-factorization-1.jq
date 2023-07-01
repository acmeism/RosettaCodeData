def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;

# for infinite precision integer-arithmetic
def idivide($p; $q): ($p - ($p % $q)) / $q ;
def idivide($q): (. - (. % $q)) / $q ;

def isqrt:
  def irt:
  . as $x
    | 1 | until(. > $x; . * 4) as $q
    | {$q, $x, r: 0}
    | until( .q <= 1;
        .q |= idivide(4)
        | .t = .x - .r - .q
        | .r |= idivide(2)
        | if .t >= 0
          then .x = .t
          | .r += .q
          else .
          end)
    | .r ;
  if type == "number" and (isinfinite|not) and (isnan|not) and . >= 0
  then irt
  else "isqrt requires a non-negative integer for accuracy" | error
  end ;
