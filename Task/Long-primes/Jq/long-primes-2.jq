# finds the period of the reciprocal of .
# (The following definition does not make a special case of 2
# but yields a justifiable result for 2, namely 1.)
def findPeriod:
  . as $n
  | (reduce range(1; $n+2) as $i (1; (. * 10) % $n)) as $rr
  | {r: $rr, period:0, ok:true}
  | until( .ok|not;
      .r = (10 * .r) % $n
      | .period += 1
      | .ok = (.r != $rr) )
  | .period ;

# This definition takes into account the
# claim in the preamble that the first long prime is 7:
def long_primes_less_than($n):
  label $out
  | primes
  | if . >= $n then break $out else . end
  | select(. > 2 and (findPeriod == . - 1));

def count_long_primes:
  count(long_primes_less_than(.));

# Since 2 is not a "long prime" for the purposes of this
# article, we can begin searching at 3:
"Long primes ≤ 500: ",  long_primes_less_than(500),

"\n",

(500,1000, 2000, 4000, 8000, 16000, 32000, 64000
| "Number of long primes ≤ \(.): \(count_long_primes)" )
