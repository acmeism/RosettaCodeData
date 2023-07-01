def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def percent: "\(100000 * . | round / 1000)%";

def pi: 4* (1|atan);

def rfloat: input/1E10;

def mcPi:
  . as $n
  | reduce range(0; $n) as $i (0;
      rfloat as $x
      | rfloat as $y
      | if ($x*$x + $y*$y <= 1) then . + 1 else . end)
   | 4 * . / $n ;

"Iterations -> Approx Pi  -> Error",
"----------    ----------    ------",
( pi as $pi
 | range(1; 7)
 | pow(10;.) as $p
 | ($p | mcPi) as $mcpi
 | ((($pi - $mcpi)|length) / $pi) as $error
 | "\($p|lpad(10))    \($mcpi|lpad(10))    \($error|percent|lpad(6))" )
