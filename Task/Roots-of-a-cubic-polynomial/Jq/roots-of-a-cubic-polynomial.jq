# Input: a possibly empty numeric array [c0, ... ]
# Emit the canonical form of the polynomial: SIGMA c[i] * x^i
def canonical:
  if length == 0 then [0]
  elif .[-1] == 0 then .[:-1]|canonical
  else .
  end;

# string representation
def poly2s: "Polynomial(\(join(",")))";

# Polynomial division
# Output [ quotient, remainder]
def divrem($divisor):
   ($divisor|canonical) as $divisor
   | { curr: canonical}
   | .base = ((.curr|length) - ($divisor|length))
   | until( .base < 0;
          (.curr[-1] / $divisor[-1]) as $res
          | .result += [$res]
          | .curr |= .[0:-1]
          |  reduce range (0;$divisor|length-1) as $i (.;
                .curr[.base + $i] +=  (- $res * $divisor[$i])  )
          | .base += -1
        )
   | [(.result | reverse),  (.curr | canonical)] ;

# Evaluate a polynomial at $x
# Input: the array representation of a polynomial
def evalPoly($x):
  length as $c
  | . as $coeffs
  | reduce range(1;length+1) as $i (0; . * $x + $coeffs[$c - $i]) ;

# Differentiate a polynomial
# Input: the array representation of the polynomial to be differentiated
def diffPoly:
  (length - 1) as $c
  | if $c == 0 then [0]
    else . as $coefs
    | reduce range(0; $c) as $i ([]; .[$i] = ($i+1) * $coefs[$i+1])
    end;

# Emit a stream
# No check is made that the input represents a quadratic polynomial
def quadraticRoots:
  . as $coefs
  | ($coefs[1]*$coefs[1] - 4*$coefs[0]*$coefs[2]) as $d
  | select($d >= 0)
  | ($d|sqrt) as $s
  | -($s + $coefs[1]), ($s - $coefs[1])
  | . / (2 * $coefs[2]);

# Attempt to find a real root of a polynomial using Newton's method from
# an initial guess, a given tolerance, a maximum number of iterations
# and a given multiplicity (usually 1).
# If a root is found, it is returned, otherwise 'null' is returned.
# If the root is near an integer, check if the integer is in fact the root.
# If the polynomical degree is 0, return null.
# Input: [c0, c1 ... ]
def rootPoly($guess; $tol; $maxIter; $mult):
  . as $coefs
  | (length - 1) as $deg
  | if $deg == 0 then null
    elif $deg == 1 then -$coefs[0]/$coefs[1]
    elif $deg == 2 then first(quadraticRoots)
    elif evalPoly(0) == 0 then 0
    else 0.001 as $eps
    | diffPoly as $deriv
    | { x0: $guess, iter: 1, return: null }
    | until(.return;
        .x0 as $x0
        | ($deriv|evalPoly($x0)) as $den
        | if $den == 0
          then .x0 |= (if . >= 0 then . + $eps else . - $eps end)
          else ($coefs|evalPoly($x0)) as $num
          | (.x0 - ($num/$den) * $mult) as $x1
          | if (($x1 - .x0)|length) <= $tol  # abs
            then ($x1 | round) as $r
            | if (($r - $x1)|length) <= $eps and ($coefs|evalPoly($r)) == 0
              then .return = $r
              else .return = $x1
              end
            else .x0 = $x1
            end
          | if .iter == $maxIter then .return = true
            else .iter += 1
            end
          end)
    | if .return != true then .return
      else (.x0|round) as $x0
      | if ($coefs | evalPoly($x0)) == 0 then $x0
        else null
        end
      end
    end;

# Convenience versions of rootPoly/4:
def rootPoly($guess):
  rootPoly($guess; 1e-15; 100; 1);
def rootPoly:
  rootPoly(0.001; 1e-15; 100; 1);

# Emit a stream of real roots
def roots:
  if length==3 then quadraticRoots
  else rootPoly as $root
  | select($root)
  | $root,
    # divide by (x - $root)
    ( divrem( [- $root, 1] ) as [$div, $rem]
      | $div
      | roots )
  end ;

# Given $root is an estimated root of the input polynomial,
# estimate the error dx from deriv = (dY / $root)
# except that if $root or deiv is 0, then use a very small value:
# since 1E-324 == 1E-325 but 1E-323 != 1E-324, we choose 1E-323
def estimatedDeltaX($root):
  1E-323 as $tiny
  | evalPoly($root) as $dY
  | (diffPoly | evalPoly($root)) as $deriv
  | if $deriv == 0 then $tiny
    else (($dY / $deriv) | length) as $dx
    | if $dx == 0 then $tiny
      else $dx
      end
    end ;

def roots_with_errors:
  rootPoly as $root
  | select($root)
  | estimatedDeltaX($root) as $dx
  | [$root, $dx],
    # divide by (x - $root)
    ( divrem( [- $root, 1] ) as [$div, $rem]
      | $div
      | roots_with_errors );

def illustration($text; $poly):
  $text,
  ($poly | roots_with_errors),
  "";

"Each root and corresponding estimated error is presented in an array.",
illustration("X^3 = 1";    [-1, 0, 0, 1] ),
illustration("X^3 - 4X^2 - 27X + 90 = 0";  # [-5, 3 ,6]
  [90, -27, -4, 1] ),
illustration("(X - 1)^3";  [-1,3,-3,1] ),
illustration("X^2 = 2";    [-2,0,1] ),
illustration("X^3 = 2";    [-2,0,0,1] )
