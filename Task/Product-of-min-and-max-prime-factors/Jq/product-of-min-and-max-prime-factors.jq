# Uncomment for gojq
# def _nwise($n):
#   def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
#   nw;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input: an integer
def isPrime:
  . as $n
  | if   ($n < 2)       then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    else 5
    | until( . <= 0;
        if .*. > $n then -1
	elif ($n % . == 0) then 0
        else . + 2
        |  if ($n % . == 0) then 0
           else . + 4
           end
        end)
    | . == -1
    end;

# Input: an integer
# Output: a stream of the prime divisors of the input, in order
def prime_divisors:
  . as $n
  | if . < 2 then empty
    elif . == 2 then 2
    else (select(. % 2 == 0) | 2),
         (range(3; ($n / 2) + 1; 2) | select( ($n % . == 0) and isPrime)),
         ($n | select(isPrime))
    end;

def greatest_prime_divisor:
  def odd: if . % 2 == 1 then . else . + 1 end;
  . as $n
  | if . < 2 then empty
    elif . == 2 then 2
    else first(
           ($n | select(isPrime)),
           ((( (($n|odd) - 1) / 2) | odd) as $odd
            | range( $odd; 2; -2) | select( ($n % . == 0) and isPrime)),
           (select(. % 2 == 0) | 2) )
    end;

# Output: a stream of the products
def productMinMaxPrimeFactors:
  1,
  (range(2; infinite)
   | [ first(prime_divisors), greatest_prime_divisor] | .[0] * .[-1]);

"Product of the smallest and greatest prime factors of n for 1 to 100:",
([limit(100; productMinMaxPrimeFactors)]
 | _nwise(10) | map(lpad(4)) | join(" "))
