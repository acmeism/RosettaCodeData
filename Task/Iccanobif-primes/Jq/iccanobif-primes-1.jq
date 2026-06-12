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
    else
      ($n | sqrt) as $rt
      | 23
      | until( . > $rt or ($n % . == 0); .+2)
      | . > $rt
    end;

# Output: an indefinitely long stream of fibonacci numbers subject to
# integer arithmetic limitations if any
def fib: [0,1]|while(1;[last,add])[1];

def reverseNumber: tostring | explode | reverse | implode | tonumber;

"First 11 Iccanobif primes:",
limit(11; fib | tostring | reverseNumber | select(is_prime))
