# The following may be omitted if using the C or Rust implementations of jq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint($columns; $width):
  reduce _nwise($columns) as $row ("";
     . + ($row|map(lpad($width)) | join(" ")) + "\n" );

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

def quad_power_primes:
  range(1; infinite)
  | . as $n
  | (reduce range(1;5) as $i ([range(0;5) | 1];
       .[$i] = $n * .[$i-1])) as $powers
  | select(all(1, 2, 3, 4;
             $powers[.] + $n + 1 | is_prime) ) ;

def qpp($n):
  "The first \($n) quad-power prime seeds:",
  ( [limit($n; quad_power_primes)]
    | tprint(10; 8) );

# qpp(50)  # too slow
qpp(27)
