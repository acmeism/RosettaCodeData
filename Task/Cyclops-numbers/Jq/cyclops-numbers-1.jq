## Generic helper functions

def count(s): reduce s as $x (0; .+1);

# counting from 0
def enumerate(s): foreach s as $x (-1; .+1; [., $x]);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

## Prime numbers
def is_prime:
  if  . == 2 then true
  else
     2 < . and . % 2 == 1 and
       (. as $in
       | (($in + 1) | sqrt) as $m
       | [false, 3] | until( .[0] or .[1] > $m; [$in % .[1] == 0, .[1] + 2])
       | .[0]
       | not)
  end ;

## Cyclops numbers

def iscyclops:
  (tostring | explode) as $d
  | ($d|length) as $l
  | (($l + 1) / 2 - 1) as $m
  | ($l % 2 == 1) and $d[$m] == 48 and count($d[] | select(.== 48)) == 1 # "0"
;

# Generate a stream of cyclops numbers, in increasing numeric order, from 0
def cyclops:
  # generate a stream of cyclops numbers with $n digits on each side of the central 0
  def w:
    if . == 0 then ""
    else (.-1)|w as $left
    | $left + (range(1;10)|tostring)
    end;
  def c: w as $left | $left + "0" + w;
  range(0; infinite) | c | tonumber;

# Generate a stream of palindromic cyclops numbers, in increasing numeric order, from 0
def palindromiccyclops:
  def r: explode|reverse|implode;
  def c: . as $n
    | if $n == 0 then "0"
      elif $n == 1
      then (range(1;10)|tostring) as $base
      | $base + "0" + ($base | r)
      else (range(pow(10;$n-1); pow(10; $n))|tostring|select(test("0")|not)) as $base
      | $base + "0" + ($base | r)
      end;
  range(0; infinite) | c | tonumber;

# check that a cyclops number minus the 0 is prime
def cyclops_isblind:
  (tostring | explode) as $d
  | ($d|length) as $l
  | (($l + 1) / 2 - 1) as $m
  | ((( $d[:$m] + $d[$m+1:] ) | implode | tonumber)  | is_prime);

# check that a cyclops number is a palindrome
def cyclops_ispalindromic:
  . as $in
  | (tostring | explode) as $d
  | ($d|length) as $l
  | (($l + 1) / 2 - 1) as $m
  |  $d[:$m] == ( $d[$m+1:] | reverse) ;
