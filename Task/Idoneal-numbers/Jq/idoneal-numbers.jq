# For gojq:
# def _nwise($n):
#   def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
#   n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def isIdoneal:
  first(
    label $out
    | . as $n
    | range(1; $n) as $a
    | label $startB
    | range($a+1; $n) as $b
    | ($a+$b) as $sum
    | ($a*$b) as $prod
    | if $prod + $sum > $n then break $startB
      else label $startC
      | range($b+1; $n) as $c
      | ($prod + $sum*$c) as $x
      | if $x == $n then 0, break $out
        elif $x > $n then break $startC
        else empty
        end
      end )
  // true | if . == 0 then false else . end;

# Search blindly
def idoneals: range(1; infinite) | select(isIdoneal);

# The task:
[limit(65; idoneals)]
 | _nwise(13) | map(lpad(5)) | join(" ")
