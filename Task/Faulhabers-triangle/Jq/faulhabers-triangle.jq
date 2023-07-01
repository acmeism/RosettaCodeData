include "Rational";

# Preliminaries
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# for gojq
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# use idivide for precision
def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) | idivide($i))
  end;

# Here we conform to the modern view that B(1) is 1 // 2
def bernoulli:
  if type != "number" or . < 0 then "bernoulli must be given a non-negative number vs \(.)" | error
  else . as $n
  | reduce range(0; $n+1) as $i ([];
        .[$i] = r(1; $i + 1)
        | reduce range($i; 0; -1) as $j (.;
            .[$j-1] = rmult($j;  rminus(.[$j-1]; .[$j])) ) )
  | .[0]  # the modern view
  end;

# Input: a non-negative integer, $p
# Output: an array of Rationals corresponding to the
# Faulhaber coefficients for row ($p + 1) (counting the first row as row 1).
def faulhabercoeffs:
  def altBernoulli:  # adjust B(1) for this task
    bernoulli as $b
    | if . == 1 then rmult(-1; $b) else $b end;
  . as $p
  | r(1; $p + 1) as $q
  | { coeffs: [], sign: -1 }
  | reduce range(0; $p+1) as $j (.;
      .sign *= -1
      | binomial($p + 1; $j) as $b
      | .coeffs[$p - $j] = ([ .sign, $q, $b, ($j|altBernoulli) ] | rmult))
  | .coeffs
;

# Calculate the sum for ($k|faulhabercoeffs)
def faulhabersum($n; $k):
  ($k|faulhabercoeffs) as $coe
  | reduce range(0;$k+1) as $i ({sum: 0, power: 1};
      .power *= $n
      | .sum = radd(.sum; rmult(.power; $coe[$i]))
      )
  | .sum;

# pretty print a Rational assumed to have the {n,d} form
def rpp:
  if .n == 0 then "0"
  elif .d == 1 then .n | tostring
  else "\(.n)/\(.d)"
  end;

def testfaulhaber:
  (range(0; 10) as $i
  | ($i | faulhabercoeffs | map(rpp | lpad(6)) | join(" "))),
    "\nfaulhabersum(1000; 17):",
    (faulhabersum(1000; 17) | rpp) ;

testfaulhaber
