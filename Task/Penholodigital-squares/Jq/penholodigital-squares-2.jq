# emit an array of [$n,$sq] values where $n is a penholodigital square in the given base
# and $n and $sq are integers expressed in that base
def penholodigital($base):
  { hi: (evalpoly($base; [range(1;$base)])|isqrt),
    lo: (evalpoly($base; [range(base-1; 0; -1)]) | isqrt)  # evalpoly(base, base-1:-1:1)
  }
  | reduce range(.lo; .hi+1) as $n (null;
       ($n * $n) as $sq
       | ($sq | digits($base)) as $digits
       | if "0" | IN($digits[]) then .
         elif (($digits | length) == $base - 1) and (($digits | unique | length) == $base-1)
         then . + [[($n | convert(base)), ($sq | convert(base))]]
         else .
         end );

def task(a;b):
  range(a;b) as $base
  | penholodigital($base)
  | "\n\nThere are \(length) penholodigital squares in base \($base):",
    (_nwise(3)
     | map("\(.[0])² = \(.[1])" )
     | join("  "));

 task(9;13)
