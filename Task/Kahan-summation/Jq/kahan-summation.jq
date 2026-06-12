def kahanSum:
  reduce .[] as $f ( { sum: 0, c: 0 };
      ($f - .c) as $y
    | (.sum + $y) as $t
    | .c = (($t - .sum) - $y)
    | .sum = $t )
  | .sum;

def epsilon:
  1 | until(1 + . == 1; ./2);

def task1:
   [10000.0, 3.14159, 2.71828]
   | "The sum of the three numbers is 10005.85987",
     "  vs using add/0:               \(add)",
     "  vs Kahan sum:                 \(kahanSum)" ;

def task2:
  1 as $a
  | epsilon as $b
  | (-$b) as $c
  | (($a + $b) + $c) as $s
  | ([$a, $b, $c] | kahanSum) as $k
  | ($k - $s) as $d
  | "b (epsilon)  = \($b)",
    "(1 + b) - b  = \($s)",
    "Kahan sum    = \($k)",
    "Delta        = \($d)"  ;

task1, "",
task2
