def ta: [
    [1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
    [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
    [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
    [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
    [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
    [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]
];

def tb:[-0.01, 0.61, 0.91, 0.99, 0.60, 0.02];

# Expected values:
def tx:[
    -0.01, 1.602790394502114, -1.6132030599055613,
    1.2454941213714368, -0.4909897195846576, 0.065760696175232
];

# Input: an array or an object
def swap($i;$j):
  .[$i] as $tmp | .[$i] = .[$j] | .[$j] = $tmp;

def gaussPartial(a0; b0):
  (b0|length) as $m
  | reduce range(0;a0|length) as $i (
      { a: [range(0;$m)|null] };
      .a[$i] = a0[$i] + [b0[$i]] )
  | reduce range(0; .a|length) as $k (.;
      .iMax = 0
      | .max = -1
      | reduce range($k;$m) as $i (.;
          .a[$i] as $row
          # compute scale factor s = max abs in row
          | .s = -1
          | reduce range($k;$m) as $j (.;
              ($row[$j]|length) as $e
              | if ($e > .s) then .s = $e else . end )
              # scale the abs used to pick the pivot
              | ( ($row[$k]|length) / .s) as $abs
              | if $abs > .max
                then .iMax = $i | .max = $abs
                else .
                end )
      | if (.a[.iMax][$k] == 0) then "Matrix is singular." | error
        else .iMax as $iMax
        | .a |= swap($k; $iMax)
        | reduce range($k + 1; $m) as $i (.;
            reduce range($k + 1; $m + 1 ) as $j (.;
              .a[$i][$j] = .a[$i][$j] - (.a[$k][$j] * .a[$i][$k] / .a[$k][$k]) )
            | .a[$i][$k] = 0 )
        end
    )
    | .x = [range(0;$m)|0]
    | reduce range($m - 1; -1; -1) as $i (.;
        .x[$i] = .a[$i][$m]
        | reduce range($i + 1; $m) as $j (.;
            .x[$i] = .x[$i] - .a[$i][$j] * .x[$j] )
        | .x[$i] = .x[$i] / .a[$i][$i] )
    | .x ;

def x: gaussPartial(ta; tb);

# Input: the array of values to be compared againt $target
def pointwise_check($target; $EPSILON):
  . as $x
  | range(0; $x|length) as $i
  | select( ($target[$i] - $x[$i])|length > $EPSILON )
  | "\($x[$i]) vs expected value \($target[$i])" ;

def task:
  x
  | ., pointwise_check(tx; 1E-14) ;

task
