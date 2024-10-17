# swap .[$i] and .[$j]
def array_swap($i; $j):
  if $i == $j then .
  else .[$i] as $t
  | .[$i] = .[$j]
  | .[$j] = $t
  end;

# element-wise subtraction: $a - $b
def array_subtract($a; $b):
  $a | [range(0;length) as $i | .[$i] - $b[$i]];

def lpad($len):
  tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Ensure -0 prints as 0
def matrix_print:
  ([.[][] | tostring | length] | max) as $max
  | .[] | map(if . == 0 then 0 else . end | lpad($max))
  | join("  ");
