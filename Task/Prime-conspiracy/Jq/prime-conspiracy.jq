# Input should be an integer
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

# The first $n primes
def sieved($n):
  [limit($n; range(2;infinite) | select(isPrime)) ];

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# right-pad with 0
def rpad($len): tostring | ($len - length) as $l | ("0" * $l)[:$l] + .;

# Input: a string of digits with up to one "."
# Output: the corresponding string representation with exactly $n decimal digits
def align_decimal($n):
  tostring
  | (capture("(?<i>[0-9]*[.])(?<j>[0-9]{0," + ($n|tostring) + "})") as $ix
     | $ix.i + ($ix.j|rpad($n)) )
  // . + "." + ($n*"0") ;

# Report the noteworthy transitions recorded in the input object
def reportTransitions:
  ([.[]] | add) as $num
  | keys as $keys
  | "For the first \($num + 1) primes, the noteworthy transitions of the last digit from prime to next-prime are:",
     ($keys[] as $key
     | .[$key] as $count
     | select($key | IN("2 => 3", "3 => 5", "5 => 7") | not)
     | ($count / $num * 100) as $freq
     | "\($key)   count: \($count|lpad(6))  frequency: \($freq | align_decimal(4))%" ) ;


def tasks:
  1E6 as $n
  | sieved($n) as $sieved
  | (1e4, 1e6) as $num
  | reduce range(1; $num) as $i ({};
        ($sieved[$i] % 10) as $p
        | ($sieved[$i-1] % 10) as $q
	| "\($q) => \($p)" as $key
	| .[$key] += 1)
  | reportTransitions, "";

tasks
