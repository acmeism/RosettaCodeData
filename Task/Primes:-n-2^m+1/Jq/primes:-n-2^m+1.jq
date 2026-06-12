# Input should be an integer
# No sqrt!
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

# Emit [m, n*2**m+1] where m is smallest non-negative integer such that n * 2**m + 1 is prime
# WARNING: continues searching ad infinitum ...
def n2m1:
  . as $n
  | first(
      foreach range(0; infinite) as $m (null;
        if . == null then 1 else 2*. end;
        (. * $n + 1)
        | select(isPrime) | [$m, .] ) ) ;

# The task:
"[N,M,Prime]\n------------------",
( range(1;45) | [.] + n2m1 )
