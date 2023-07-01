# Utility functions
def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def prod(s): reduce s as $x (1; . * $x);

def sum(s): reduce s as $x (0; . + $x);

def uniq(s):
  foreach s as $x (null;
    if . and $x == .[0] then .[1] = false
    else [$x, true]
    end;
    if .[1] then .[0] else empty end);


# Prime number functions

# Returns the prime factors of . in order using a wheel with basis [2, 3, 5].
def primeFactors:
  def out($i): until (.n % $i != 0; .factors += [$i] | .n = ((.n/$i)|floor) );
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
        then .factors += [.k]
        | .n = ((.n/.k)|floor)
        else .k += $inc[.i]
        | .i = ((.i + 1) % 8)
        end)
    | if .n > 1 then .factors += [.n] else . end

  | .factors
  end;

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

# Number of primes up to and including .
def primeCount:
  sum(primeSieve[] | select(.) | 1);


## Radicals

def task1:
{ radicals: [0],
  counts:   [range(0;8)|0] }
| .radicals[1] = 1
| .counts[1] = 1
| foreach range(2; 1+1e6) as $i (.;
    .factors = [uniq($i|primeFactors[])]
    | (.factors|length) as $fc
    | .counts[$fc] += 1
    | if $i <= 50 then .radicals[$i] = prod(.factors[]) else . end ;

    if $i == 50
    then "The radicals for the first 50 positive integers are:",
         (.radicals[1:] | _nwise(10) | map(lpad(4)) | join(" ")),
	 ""

    elif $i | IN( 99999, 499999, 999999)
    then "Radical for \($i|lpad(8)): \(prod(.factors[])|lpad(8))"
    elif $i == 1e6
    then  "\nBreakdown of numbers of distinct prime factors",
        "for positive integers from 1 to 1,000,000:",
        (range(1; 8) as $i
         | "  \($i): \(.counts[$i]|lpad(8))"),
         "    ---------",
         "    \(sum(.counts[]))"
    else empty
    end);

def task2:
  def pad: lpad(6);

  (1000|primeSieve|map(select(.))) as $primes1k
  | { pcount: (1e6|primeCount),
      ppcount: 0 }
  | reduce $primes1k[] as $p (.;
      .p2 = $p
      | .done = false
      | until(.done;
          .p2 *= $p
          | if .p2 > 1e6 then .done = true
	    else .ppcount += 1
	    end ) )
  | "\nFor primes or powers (>1) thereof <= 1,000,000:",
    "  Number of primes   = \(.pcount|pad)",
    "  Number of powers   = \(.ppcount|pad)",
    "  Add 1 for number 1 = \(1|pad)",
    "                       ------",
    "                       \( (.pcount + .ppcount + 1)|pad)" ;

task1, task2
