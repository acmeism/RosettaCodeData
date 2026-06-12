# This def may be omitted if using jq
def _nwise($n):
  def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
  nw;

# Evaluate SIGMA $x^k * $p[k] for k=0...
def evalpoly($x; $p):
  reduce range(0;p|length) as $i ({power: 1, sum:0};
      .sum += .power * $p[$i]
      | .power *= $x)
  | .sum;

# Convert the input integer to a string in the specified base (2 to 36 inclusive)
def convert(base):
  def stream:
    recurse(if . >= base then ./base|floor else empty end) | . % base ;
  [stream] | reverse
  | if   base <  10 then map(tostring) | join("")
    elif base <= 36 then map(if . < 10 then 48 + . else . + 87 end) | implode
    else error("base too large")
    end
  end;

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# input should be a non-negative integer for accuracy
# but may be any non-negative finite number
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

# Input: an integer base 10
# Output: an array of the digits (characters) if . were printed in base $base
def digits($base):
  convert($base) | tostring | [explode[] | [.] | implode];
