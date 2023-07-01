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
    elif ($n % 23 == 0) then $n == 23
    elif ($n % 29 == 0) then $n == 29
    elif ($n % 31 == 0) then $n == 31
    else 37
         | until( (. * .) > $n or ($n % . == 0); . + 2)
         | . * . > $n
    end;

def task:

  # a helper function for keeping count:
  def record($p; counter6; counter7):
    if $p < 10000000
    then counter7 += 1
    | if $p < 1000000
      then counter6 += 1
      else .
      end
    else .
    end;

  # a helper function for recording up to $max values
  def recordValues($max; $p; a; done):
     if done then .
     elif a|length < $max
     then a += [$p] | done = ($max == (a|length))
     else .
     end;

  10000000 as $n
  | reduce (2, range(3;$n;2)) as $p ({};
      if $p|is_prime
      then if (($p - 1) / 2) | is_prime
           then recordValues(35; $p; .safeprimes; .safedone)
           | record($p; .nsafeprimes6; .nsafeprimes7)
           else  recordValues(40; $p; .unsafeprimes; .unsafedone)
           | record($p; .nunsafeprimes6; .nunsafeprimes7)
           end
      else .
      end )
  | "The first 35 safe primes are: ", .safeprimes[0:35],
    "\nThere are \(.nsafeprimes6) safe primes less than 1 million.",
    "\nThere are \(.nsafeprimes7) safe primes less than 10 million.",
    "",
    "\nThe first 40 unsafe primes are:", .unsafeprimes[0:40],
    "\nThere are \(.nunsafeprimes6) unsafe primes less than 1 million.",
    "\nThere are \(.nunsafeprimes7) unsafe primes less than 10 million."
;

task
