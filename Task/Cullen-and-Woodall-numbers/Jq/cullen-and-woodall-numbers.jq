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

def ipow($m; $n): reduce range(0;$n) as $i (1; $m * .);

def cullen: ipow(2;.) * . + 1;

def woodall: cullen - 2;

def task:
  "First 20 Cullen numbers (n * 2^n + 1):",
  (range(1; 21) | cullen),
  "\n\nFirst 20 Woodall numbers (n * 2^n - 1):",
  (range(1; 21) | woodall),

  "\n\nFirst Cullen primes (in terms of n):",
  limit(1;
    range(1; infinite)
    | select(cullen|is_prime) ),

  "\n\nFirst 4 Woodall primes (in terms of n):",
  limit(4;
    range(0; infinite)
    | select(woodall|is_prime) ) ;

task
