### Complex numbers
def plus(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x+y, 0 ]
       else [ x + y[0], y[1]]
       end
    elif (y|type) == "number" then plus(y;x)
    else [ x[0] + y[0], x[1] + y[1] ]
    end;

def multiply(x; y):
    if (x|type) == "number" then
       if  (y|type) == "number" then [ x*y, 0 ]
       else [x * y[0], x * y[1]]
       end
    elif (y|type) == "number" then multiply(y;x)
    else [ x[0] * y[0] - x[1] * y[1],  x[0] * y[1] + x[1] * y[0]]
    end;

### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Require $n > 0
def nwise($n):
  def _n: if length <= $n then . else .[:$n] , (.[$n:] | _n) end;
  if $n <= 0 then "nwise: argument should be non-negative" else _n end;

def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else sqrt as $s
    | 23
    | until( . > $s or ($n % . == 0); . + 2)
    | . > $s
    end;

def OMEGA: [-0.5, (3|sqrt * 0.5)];

### Eisenstein numbers and Eisenstein primes

def Eisenstein($a; $b):
   {$a, $b, n: plus( multiply(OMEGA;$b); $a) };

def realEisenstein: .n[0];
def imagEisenstein: .n[1];
def normEisenstein:
   .a *.a - .a * .b + .b * .b ;

# Replicate the Julia sort order for easy comparison
def sortEisenstein:
   sort_by( [ normEisenstein, imagEisenstein, realEisenstein] );

def isPrimeEisenstein:
    if .a == 0 or .b == 0 or .a == .b
    # length ~ abs
    then ([.a, .b] | map(length) | max) as $c
    | ($c | is_prime) and $c % 3 == 2
    else normEisenstein | is_prime
    end;

# Eisenstein($i;$j) primes for $i and $j in -$n .. $n inclusive
def eprimes($n):
  reduce range (-$n; $n+1) as $a ([];
    reduce range ( -$n; $n+1) as $b (.;
      Eisenstein($a; $b) as $e
      | if $e | isPrimeEisenstein
        then . + [$e]
        else .
        end ));

### The tasks

# pretty-print a complex number
def pp:
  def r: 100 * . | trunc / 100;
  .[2] = (if .[1] < 0 then "-" else "+" end)
  | .[1] |= (if . < 0 then -. else . end)
  | "\(.[0]|r|lpad(5)) \(.[2]) \(.[1]|r|lpad(5))i";

# Display the input array of complex numbers as a table with $n columns
# proceeding row-wise and using pp/0
def row_wise($n):
  nwise($n) | map( pp ) | join("  ");

def listing:
  {eprimes: (eprimes(10) | sortEisenstein) }
  # convert to Complex numbers for easy display
  | .eprimes |= map( .n )
  | "First 100 Eisenstein primes nearest zero:",
    (.eprimes[:100] | row_wise(4) );

def graph:
  eprimes(100)
  | sortEisenstein
  | .[:2000][]
  | .n
  | "\(real(.)) \(imag(.))";

# For a listing of the first 100 Eisenstein primes nearest 0:
listing

# To produce the points for gnuplot:
# graph
