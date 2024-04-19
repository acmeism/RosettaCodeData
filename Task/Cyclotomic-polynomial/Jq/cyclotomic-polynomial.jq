### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Return the maximum item in the stream assuming it is not empty:
def max(s): reduce s as $s (null; if . == null then $s elif $s > . then $s else . end);

# Truncated integer division (consistent with % operator).
# `round` is used for the sake of jaq.
def quo($x; $y): ($x - ($x%$y)) / $y | round;

### Primes
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

# Emit an array of the distinct prime factors of 'n' in order using a wheel
# with basis [2, 3, 5], e.g. 44 | distinctPrimeFactors #=> [2,11]
def distinctPrimeFactors:
  def augment($x): if .[-1] == $x then . else . + [$x] end;
  def out($i):
    if (.n % $i) == 0
    then .factors += [$i]
    | until (.n % $i != 0; .n = ((.n/$i)|floor) )
    else .
    end;

  if . < 2 then []
  else [4, 2, 4, 2, 4, 6, 2, 6] as $inc
    | { n: .,
        factors: [] }
    | out(2)
    | out(3)
    | out(5)
    | .k = 7
    | .i = 0
    | until(.k * .k > .n;
        if .n % .k == 0
        then .k as $k | .factors |= augment($k)
        | .n = ((.n/.k)|floor)
        else .k += $inc[.i]
        | .i = ((.i + 1) % 8)
        end)
    | if .n > 1 then .n as $n | .factors |= augment($n) else . end
  | .factors
  end;

### Polynomials
def canonical:
  if length == 0 then .
  elif .[-1] == 0 then .[:-1]|canonical
  else .
  end;

# For pretty-printing the input array as the polynomial it represents
# e.g. [1,-1] => x-1
def pp:
  def digits: tostring | explode[] | [.] | implode | tonumber;
  def superscript:
    if . <= 1 then ""
    else ["\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074", "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"] as $ss
    | reduce digits as $d (""; . + $ss[$d] )
    end;

  if length == 1 then .[0] | tostring
  else reverse as $p
  | reduce range(length-1; -1; -1) as $i ([];
        if $p[$i] != 0
	then (if $i > 0 then "x" else "" end) as $x
        | ( if $i > 0 and ($p[$i]|length) == 1
	    then (if $p[$i] == 1 then "" else "-" end)
	    else ($p[$i]|tostring)
	    end ) as $c
	| . + ["\($c)\($x)\($i|superscript)"]
        else . end )
    | join("+")
    | gsub("\\+-"; "-")
    end ;

def polynomialDivide($divisor):
   . as $in
   | ($divisor|canonical) as $divisor
   | { curr: canonical}
   | .base = ((.curr|length) - ($divisor|length))
   | until( .base < 0;
            (.curr[-1] / $divisor[-1]) as $res
            | .result += [$res]
            | .curr |= .[:-1]
            |  reduce range (0;$divisor|length-1) as $i (.;
                 .curr[.base + $i] +=  (- $res * $divisor[$i])  )
            | .base += -1 )
   | (.result | reverse) as $quot
   | (.curr | canonical) as $rem
   | [$quot, $rem];

# Call `round` for the sake of jaq
def exactDivision($numerator; $denominator):
  ($numerator | polynomialDivide($denominator))
  | .[0]
  | map(round);

def init($n; $value): [range(0;$n)|$value];

### Cyclotomic Polynomials

# The Cyclotomic Polynomial obtained from $polynomial
# by replacing x with x^$exponent
def substituteExponent($polynomial; $exponent):
  init( ($polynomial|length - 1) * $exponent + 1; 0)
  | reduce range(0; $polynomial|length) as $i (.; .[$i*$exponent] = $polynomial[$i]);

# Return the Cyclotomic Polynomial of order 'cpIndex' as a JSON array of coefficients,
# where, for example, the polynomial 3x^2 - 1 is represented by [3, 0, -1].
def cycloPoly($cpIndex):
 { polynomial: [1, -1] }
 | if $cpIndex == 1 then .polynomial
   elif ($cpIndex|is_prime) then [range(0; $cpIndex) | 1 ]
   else .product = 1
   | reduce  ($cpIndex | distinctPrimeFactors[]) as $prime (.;
         substituteExponent(.polynomial; $prime) as $numerator
         | .polynomial = exactDivision($numerator; .polynomial)
         | .product *= $prime )
   | substituteExponent(.polynomial; quo($cpIndex; .product) )
   end;

# The Cyclotomic Polynomial equal to $dividend / $divisor
def exactDivision($dividend; $divisor):
  reduce range(0; 1 + ($dividend|length) - ($divisor|length)) as $i ($dividend;
    if .[$i] != 0
    then reduce range(1; $divisor|length) as $j (.;
      .[$i+$j] = .[$i+$j] - $divisor[$j] * .[$i] )
    else .
    end)
  | .[0: 1 + length - ($divisor|length)];

### The tasks
def task1($n):
  "Task 1: Cyclotomic polynomials for n <= \($n):",
  ( range(1;$n+1) | "CP[\(lpad(2))]: \(cycloPoly(.)|pp)" );

# For range(1;$n+1) as $c, report the first cpIndex which has a coefficient
# equal in magnitude to $c, possibly reporting others as well.
def task2($n):
  def height: max(.[]|length); # i.e. abs
  # update .summary and .todo
  def register($cpIndex):
    cycloPoly($cpIndex) as $poly
    | if ($poly|height) < .todo[0] then .
      else # it is a palindrome so we can halve the checks
        reduce ($poly | .[0: quo(length + 1; 2)][]|length|select(.>1)) as $c (.;
          if .summary[$c|tostring] then .
          else .summary[$c|tostring] = $cpIndex
          | .todo -= [$c]
          | debug
          end)
      end;

  {cpIndex:1, summary: {"1": 1}, todo: [range(2; $n + 1)]}
  | until(.todo|length == 0;
      if .cpIndex|is_prime then . else register(.cpIndex) end
      | .cpIndex += 1)
  | .summary
  | (keys | sort_by(tonumber)[]) as $key
  | "CP[\(.[$key]|lpad(5))] has a coefficient with magnitude \($key)"
  ;

task1(30),
"",
task2(10)
