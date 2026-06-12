### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def sum(s): reduce s as $x (0; .+$x);

# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;

### Prime number functions

# Input:  a positive integer
# Output: an array, $a, of length .+1 such that
#         $a[$i] is $i if $i is prime, and false otherwise.
def primeSieve:
  # erase(i) sets .[i*j] to false for integral j > 1
  def erase($i):
    if .[$i] then
      reduce (range(2*$i; length; $i)) as $j (.; .[$j] = false)
    else .
    end;
  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i)) ;

# Number of primes up to and including $n,
# assuming . is a sufficiently large
# array as produced by primeSieve
def primeCount($n):
  sum(.[] | select(. and . <= $n) | 1);


### Specialized functions

# collect at most 3 divisors
def eligible_divisors:
  . as $n
  | ($n|sqrt) as $sqrt
  | {divisors: [],
     i: 1,
     k: (if $n%2 == 0 then 1 else 2 end)
    }
  | until (.i > $sqrt;
        if .i > 1 and ($n%.i == 0)  # exclude 1 and n
        then .divisors += [.i]
        | if (.divisors|length > 2) then .i = $sqrt + 1 # i.e. break
          else (($n/.i)|floor) as $j
          | if $j != .i then .divisors += [$j] end
          end
        end
        | .i += .k )
  | .divisors ;

# First give details for the multiplicatively-perfect numbers under $n
# then give counts for 500 * 10^k <= $upto
def task($n; $upto):
  def p: lpad(4);
  "Multiplicatively perfect numbers under \($n):",
  ( ($upto | primeSieve) as $sieved
    | { limit: 500,
       count: 0,
       line: "",
       i: 1 }
    | whilst( .limit <= $upto;
        .emit = null
        | (.i | if (. != 1) then eligible_divisors else [1, 1] end ) as $pd
        | if ($pd|length) == 2 and ($pd[0] * $pd[1]) == .i
          then .count += 1
          | if .i < $n
            then .line +=  "\(.i|lpad(3))  =\($pd[0]|p) x\($pd[1]|p)   "
            | if .count % 5 == 0
              then .emit = .line
              | .line = ""
              end
            end
          end
          | if .i == $n - 1
            then .emit = .line + "\n"
            | .line = ""
            end
          | (.limit - 1) as $l
          | if .i == $l
            then ($sieved | primeCount($l|sqrt|floor)) as $squares
            |    ($sieved | primeCount($l|cbrt|floor)) as $cubes
            |     (.count + $squares - $cubes - 1) as $count2
            | .emit += "Counts under \(.limit|lpad(8)): MPNs = \(.count|lpad(6))  Semi-primes = \($count2|lpad(6))"
            | .limit *= 10
            end
         | .i += 1 )
    | select(.emit).emit
  );

task(500; 500000)
