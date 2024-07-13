def N: 32;

# Input: {x,y,r}
# Output: update r and set .result
def rho($i; $n):
  if $n < 0 then .result = 0
  elif $n == 0 then .result = .y[$i]
  else (((N - 1 - $n) * (N - $n) / 2) + $i) as $idx
  | if (.r[$idx] == null)
    then
      rho($i; $n - 1)       | .result as $r1
      | rho($i + 1; $n - 1) | .result as $r2
      | rho($i + 1; $n - 2) | .result as $r3
      | .r[$idx] = (.x[$i] - .x[$i + $n]) / ($r1 - $r2) + $r3
    end
  | .result = .r[$idx]
  end;

# Input: {x,y,r}
# Output: update r and set .result
def thiele($xin; $n):
  if $n > N - 1 then .result = 1
  else
     rho(0; $n)             | .result as $r1
     | rho(0; $n -2)        | .result as $r2
     | thiele($xin; $n + 1) | .result as $t
     | .result = ($r1 - $r2) + ($xin - .x[$n]) / $t
  end;

# Output: {xval, tsin, tcos, ttan}
def init($step):
  reduce range(0; N) as $i ({};
    ($i * $step) as $x
    | .xval[$i] = $x
    | .tsin[$i] = ($x|sin)
    | .tcos[$i] = ($x|cos)
    | .ttan[$i] = .tsin[$i] / .tcos[$i] ) ;

init(0.05)
| ({r: [], x: .tsin, y: .xval} | 6 * thiele(0.5; 0).result),
  ({r: [], x: .tcos, y: .xval} | 3 * thiele(0.5; 0).result),
  ({r: [], x: .ttan, y: .xval} | 4 * thiele(1.0; 0).result)
