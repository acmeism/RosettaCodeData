# ⊕ operator
def Tropical::add($other):
  [., $other] | max;

# ⊗ operator
def Tropical::mul($other):
  . + $other;

# Tropical exponentiation
def Tropical::exp($e):
   if ($e|type) == "number" and ($e | . == floor)
   then if ($e == 1) then .
        else . as $in
        | reduce range (2;1+$e) as $i (.; Tropical::mul($in))
        end
   else "Tropical::exp(\($e)): argument must be a positive integer." | error
   end ;

# pretty print a number as a Tropical number
def pp:
   if isinfinite then if . > 0 then "infinity" else "-infinity" end
   else .
   end;

def data: [
    [2, -2, "⊗"],
    [-0.001, -infinite, "⊕"],
    [0, -infinite, "⊗"],
    [1.5, -1, "⊕"],
    [-0.5, 0, "⊗"]
];

def task1:
  data[] as [$a, $b, $op]
  | if $op == "⊕"
    then "\($a|pp) ⊕ \($b|pp) = \($a | Tropical::add($b) | pp)"
    else
         "\($a|pp) ⊗ \($b|pp) = \($a | Tropical::mul($b) | pp)"
    end;

def task2:
  5 as $c
  | "\($c|pp) ^ 7 = \($c | Tropical::exp(7) | pp)";

def task3:
    5 as $c
  | 8 as $d
  | 7 as $e
  | ($c | Tropical::mul($d) | Tropical::add($e)) as $f
  | ($c | Tropical::mul($d) | Tropical::add( $c | Tropical::mul($e))) as $g
  | "\($c) ⊗ (\($d) ⊕ \($e)) = \($f | pp)",
    "\($c) ⊗ \($d) ⊕ \($c) ⊗ \($e) = \($g | pp)",
    "\($c) ⊗ (\($d) ⊕ \($e)) == \($c) ⊗ \($d) ⊕ \($c) ⊗ \($e) is \($f == $g)"   ;

task1, task2, task3
