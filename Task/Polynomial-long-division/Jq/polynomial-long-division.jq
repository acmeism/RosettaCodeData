# Emit the canonical form of the polynomical represented by the input array
def canonical:
  if length == 0 then .
  elif .[-1] == 0 then .[:-1]|canonical
  else .
  end;

# string representation
def poly2s: "Polynomial(\(join(",")))";

# Polynomial division
# Output [ quotient, remainder]
def divrem($divisor):
   ($divisor|canonical) as $divisor
   | { curr: canonical}
   | .base = ((.curr|length) - ($divisor|length))
   | until( .base < 0;
          (.curr[-1] / $divisor[-1]) as $res
          | .result += [$res]
          | .curr |= .[0:-1]
          |  reduce range (0;$divisor|length-1) as $i (.;
                .curr[.base + $i] +=  (- $res * $divisor[$i])  )
          | .base += -1
        )
   | (.result | reverse),  (.curr | canonical)];

def demo($num; $den):
  {$num, $den,
    res: ($num | divrem($den)) }
   | .quot = .res[0]
   | .rem  = .res[1]
   | del(.res)
   | map_values(poly2s)
   | "\(.num) / \(.den) = \(.quot) remainder \(.rem)";

demo( [-42, 0, -12, 1]; [-3, 1, 0, 0])
