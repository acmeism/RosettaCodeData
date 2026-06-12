def mapRange($x; $min; $max; $minTo; $maxTo):
  (($x - $min)/($max - $min))*($maxTo - $minTo) + $minTo;

def chebCoeffs(func; n; min; max):
  (1 | atan * 4) as $pi
  | reduce range(0;n) as $i ([]; # coeffs
      ((mapRange( ($pi * ($i + 0.5) / n)|cos; -1; 1; min; max) | func) * 2 / n) as $f
      | reduce range(0;n) as $j (.;
          .[$j] +=  $f * ($pi * $j * (($i + 0.5) / n)|cos)) );

def chebApprox(x; n; min; max; coeffs):
  if n < 2 or (coeffs|length) < 2 then "'n' can't be less than 2." | error
  else { a: 1,
         b: mapRange(x; min; max; -1; 1) }
  | .res = coeffs[0]/2 + coeffs[1]*.b
  | .xx = 2 * .b
  | reduce range(2;n) as $i (.;
       (.xx * .b - .a) as $c
       | .res += coeffs[$i]*$c)
       | .a = .b
       | .b = $c)
  | .res
  end ;

def task:
    [10, 0, 1] as [$n, $min, $max]
  |  chebCoeffs(cos; $n; $min; $max) as $coeffs
  | "Coefficients:",
     ($coeffs[]|pp(2;14)),
     "\nApproximations:\n  x      func(x)    approx       diff",
     (range(0;21) as $i
      | mapRange($i; 0; 20; $min; $max) as $x
      | ($x|cos) as $f
      | chebApprox($x; $n; $min; $max; $coeffs) as $approx
      | ($approx - $f) as $diff
      | [ ($x|pp(0;3)|rpad( 4;"0")),
          ($f|pp(0;8)|rpad(10;"0")),
	  ($approx|pp(0;8)),
          ($diff  |pp(2;2)) ]
      | join("  ") );

task
