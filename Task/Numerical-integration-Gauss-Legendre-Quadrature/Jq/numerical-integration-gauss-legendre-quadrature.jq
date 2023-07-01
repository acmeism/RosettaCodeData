# output: an array
def legendreCoef($N):
  {lcoef: (reduce range(0;$N+1) as $i (null; .[$i] = [range(0;$N + 1)| 0]))}
  | .lcoef[0][0] = 1
  | .lcoef[1][1] = 1
  | reduce range(2; $N+1) as $n (.;
      .lcoef[$n][0] = -($n-1) * .lcoef[$n -2][0] / $n
      | reduce range (1; $n+1) as $i (.;
          .lcoef[$n][$i] = ((2*$n - 1) * .lcoef[$n-1][$i-1] - ($n - 1) * .lcoef[$n-2][$i]) / $n ) )
  | .lcoef ;

# input: lcoef
# output: the value
def legendreEval($n; $x):
  . as $lcoef
  | reduce range($n; 0 ;-1) as $i ( $lcoef[$n][$n] ;  . * $x + $lcoef[$n][$i-1] ) ;

# input: lcoef
def legendreDiff($n; $x):
  $n * ($x * legendreEval($n; $x) - legendreEval($n-1; $x)) / ($x*$x - 1) ;

# input: lcoef
# output: {lroots, weight}
def legendreRoots($N):
  def pi: 1|atan * 4;
  . as $lcoef
  | { x: 0, x1: null}
  | reduce range(1; 1+$N) as $i (.;
     .x = ((pi * ($i - 0.25) / ($N + 0.5)) | cos )
      | until (.x == .x1;
         .x1 = .x
         | .x as $x
         | .x = .x - ($lcoef | (legendreEval($N; $x) / legendreDiff($N; $x) )) )
      | .lroots[$i-1] = .x
      | .x as $x
      | .x1 = ($lcoef|legendreDiff($N; $x))
      | .weight[$i-1] = 2 / ((1 - .x*.x) * .x1 * .x1) ) ;

# Input: {lroots, weight}
def legendreIntegrate(f; $a; $b; $N):
  .lroots as $lroots
  | .weight as $weight
  | (($b - $a) / 2) as $c1
  | (($b + $a) / 2) as $c2
  | reduce range(0;$N) as $i (0; . + $weight[$i] * (($c1* $lroots[$i] + $c2)|f) )
  | $c1 * .;

def task($N):
  def actual: 3|exp - ((-3)|exp);

  legendreCoef($N)
  | legendreRoots($N)
  | "Roots: ",
    .lroots,
    "\nWeight:",
    .weight,

    "\nIntegrating exp(x) over [-3, 3]: \(legendreIntegrate(exp; -3; 3; N))",
    "compared to actual:              \(actual)" ;

task(5)
