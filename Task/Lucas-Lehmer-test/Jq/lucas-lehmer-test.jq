# To take advantage of gojq's arbitrary-precision integer arithmetic:
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
    else {i:23}
         | until( (.i * .i) > $n or ($n % .i == 0); .i += 2)
	 | .i * .i > $n
    end;

# using the Lucac-Lehmer test for p>2, emit a stream of the form
# Mp:l where p is a Mersenne_prime and l is (p|tostring|length).
# 2^1 - 1 = 2 so we begin with M2:1.
def mersenne_primes:
  "M2:1",
  (range(3;infinite;2)
   | . as $i
   | select(is_prime)
   | . as $p
   | ((2 | power($p)) - 1) as $mp
   | select(0 == (reduce range(3; $p + 1) as $_ (4; (power(2) -2) % $mp) ) )
   |  "M\($i):\($mp|tostring|length)" );

mersenne_primes
