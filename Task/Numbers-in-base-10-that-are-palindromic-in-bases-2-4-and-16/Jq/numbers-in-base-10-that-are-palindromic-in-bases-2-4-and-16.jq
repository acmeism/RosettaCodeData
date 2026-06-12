def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# nwise/2 assumes that null can be taken as the eos marker
def nwise(stream; $n):
  foreach (stream, null) as $x ([];
    if length == $n then [$x] else . + [$x] end;
    if (.[-1] == null) and length>1 then .[:-1]
    elif length == $n then .
    else empty
    end);

def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

# boolean
def palindrome: explode as $in | ($in|reverse) == $in;

# boolean
def palindrome($b):
  tobase($b) | palindrome;

def task($n):
  "Numbers under \($n) in base 10 which are palindromic in bases 2, 4 and 16:",
  (nwise(range(0;$n) | select(palindrome(2) and palindrome(4) and palindrome(16)); 5)
   | map( lpad(6) ) | join(" "));

task(25000)
