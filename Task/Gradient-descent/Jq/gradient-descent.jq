def sq: .*.;

def ss(stream): reduce stream as $x (0; . + ($x|sq));

# Function for which minimum is to be found: input is a 2-array
def g:
  . as $x
  | (($x[0]-1)|sq) *
        (( - ($x[1]|sq))|exp) + $x[1]*($x[1]+2) *
        ((-2*($x[0]|sq))|exp);

# Provide a rough calculation of gradient g(p):
def gradG:
  . as [$x, $y]
  | ($x*$x) as $x2
  | [2*($x-1)*(-($y|sq)|exp) - 4 * $x * (-2*($x|sq)|exp) * $y*($y+2),
     - 2*($x-1)*($x-1)*$y*((-$y*$y)|exp)
	    + ((-2*$x2)|exp)*($y+2) + ((-2*$x2)|exp)*$y] ;

def steepestDescent(g; gradG; $x; $alpha; $tolerance):
  ($x|length) as $n
  | {g0   : (x|g),          # Initial estimate of result
     alpha: $alpha,
        fi: ($x|gradG),      # Calculate initial gradient
	 x: $x,
     iterations: 0
    }

   # Calculate initial norm:
   | .delG = (ss( .fi[] ) | sqrt )
   | .b = .alpha/.delG

   # Iterate until value is <= $tolerance:
   | until (.delG <= $tolerance;
        .iterations += 1
        # Calculate next value:
        | reduce range(0; $n) as $i(.;
	    .x[$i] +=  (- .b * .fi[$i]) )

        # Calculate next gradient:
        | .fi = (.x|gradG)

        # Calculate next norm:
        | .delG = (ss( .fi[] ) | sqrt)
        | .b = .alpha/.delG

        # Calculate next value:
        | .g1 = (.x|g)

        # Adjust parameter:
        | if .g1 > .g0
          then .alpha /= 2
          else .g0 = .g1
          end
       ) ;

def tolerance: 0.0000006;
def alpha: 0.1;
def x: [0.1, -1]; # Initial guess of location of minimum.

def task:
  steepestDescent(g; gradG; x; alpha; tolerance)
  | "Testing the steepest descent method:",
    "After \(.iterations) iterations,",
    "the minimum is at x = \(.x[0]), y = \(.x[1]) for which f(x, y) = \(.x|g)." ;

task
