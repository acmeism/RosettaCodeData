# This function emits a possibly empty stream of arrays.
# Assuming $primes is primes(.), each array corresponds to a
# partition of the input into $n distinct primes.
# The algorithm is unoptimized.
# The output is a stream of arrays, which would be empty
def primepartition($n; $primes):
  . as $x
  | if $n == 1
    then if $primes[-1] == $x then [$x] else null end
    else (if $primes[-1] == $x then $primes[:-1] else $primes end) as $primes
    | ($primes | take($n; $x))
    end ;

# See primepartition/2
def primepartition($n):
  . as $x
  | if $n == 1
    then if is_prime then [.] else null end
    else primepartition($n; [primes($x)])
    end;

# Compute first(primepartition($n)) for each $n in the array $ary
def primepartitions($ary):
  . as $x
  | [primes($x)] as $px
  | $ary[] as $n
  | $x
  | first(primepartition($n; $px));

def task($x; $n):
  def pp:
    if . then join("+") else "(not possible)" end;

  if $n|type == "array" then task($x; $n[])
  else "A partition of \($x) into \($n) parts: \(first($x | primepartition($n)) | pp )"
  end;
