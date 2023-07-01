include "rational" {search: "."};  the defs at  [[Arithmetic/Rational#jq]]

def names:
  ["Platinum", "Golden", "Silver", "Bronze", "Copper","Nickel", "Aluminium", "Iron", "Tin", "Lead"];

def lucas($b):
   [1,1] | recurse( [last, first + $b*last] ) | first;

def lucas($b; $n):
  "Lucas sequence for \(names[$b]) ratio, where b = \($b):",
  "First \(n) elements: ",
  [limit($n; lucas($b))];

# dp = integer (degrees of precision)
def metallic(b; dp):
  { x0: 1,
    x1: 1,
    x2: 0,
    ratio: r(1; 1),
    iters: 0 }
  | .prev = (.ratio|r_to_decimal(dp))  # a string
  | until(.emit;
      .iters += 1
      | .x2 = .b * .x1 + .x0
      | .ratio = r(.x2; .x1)
      | .curr = (.ratio|r_to_decimal(dp))  # a string
      | if .prev == .curr
        then (if (.iters == 1) then " " else "s" end) as $plural
        | .emit = "Value to \(dp) dp after \(.iters) iteration\($plural): \(.curr)\n"
        else .prev = .curr
        | .x0 = .x1
        | .x1 = .x2
	end )
  | .emit;

(range( 0;10) | lucas(.; 15), metallic(.; 32)),

"Golden ratio, where b = 1:",  metallic(1; 256)
