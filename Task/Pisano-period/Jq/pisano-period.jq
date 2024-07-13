### In case gojq is used:
# Require $n > 0
def _nwise($n):
  def _n: if length <= $n then . else .[:$n] , (.[$n:] | _n) end;
  if $n <= 0 then "nwise: argument should be non-negative" else _n end;

### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def lcm($m; $n):
  # The helper function takes advantage of jq's tail-recursion optimization
  def _lcm:
    # state is [m, n, i]
    if (.[2] % .[1]) == 0 then .[2] else (.[0:2] + [.[2] + $m]) | _lcm end;
  [$m, $n, $m] | _lcm;

# Preserve integer accuracy as much as the implementation of jq allows
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

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

# Emit an array of the prime factors of . in order using a wheel with basis [2, 3, 5]
# e.g. 44 | primeFactors => [2,2,11]
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
    | if .n > 1 then .factors += [ .n ] else . end
  | .factors
  end;

# Calculate the Pisano period of . from first principles.
def pisanoPeriod:
  . as $m
  | {p: 0, c: 1}
  | first(foreach range(0; $m*$m) as $i (.;
      .p as $t
      | .p = .c
      | .c = ($t + .c) % $m;
      select(.p == 0 and .c == 1) | $i + 1
    )) //  1;

# Calculate the Pisano period of $p^$k where $p is prime and $k is a positive integer.
def pisanoPrime($p; $k):
  $p
  | if (is_prime|not) or $k == 0 then 0   # no can do
    else ( power($k-1) * pisanoPeriod )
    end;

# Calculate the Pisano period of . using pisanoPrime/2.
def pisano:
  . as $m
  | (reduce primeFactors[] as $p ({}; .[$p|tostring] += 1)
     | to_entries | map([(.key|tonumber), .value]) ) as $primePowers
  | (reduce $primePowers[] as [$p, $n] ([];
        . + [ pisanoPrime($p;$n) ] ) ) as $pps
  | ($pps|length) as $ppsl
  | if $ppsl == 0 then 1
    elif $ppsl == 1 then $pps[0]
    else {f: $pps[0], i: 1}
    | until(.i >= $ppsl;
        .f = lcm(.f; $pps[.i])
        | .i += 1)
    | .f
    end;

def examples:
  (range( 2; 15)
   | pisanoPrime(.; 2) as $pp
   | select($pp > 0)
   | "pisanoPrime(\(.); 2) = \($pp)" ),
  "",
  (range( 2; 180)
   | pisanoPrime(.; 1) as $pp
   | select($pp > 0)
   | "pisanoPrime(\(.);1) = \($pp)" )
;

examples,
"\npisano(n) for integers 'n' from 1 to 180 are:",
( [range(1; 181) | pisano ]
  | _nwise(15)
  | map(lpad(3))
  | join(" "))
