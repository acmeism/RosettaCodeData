# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($i; $j):
  ($i % $j) as $mod
  | ($i - $mod) / $j ;
def idivide($j):
  idivide(.; $j);

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
