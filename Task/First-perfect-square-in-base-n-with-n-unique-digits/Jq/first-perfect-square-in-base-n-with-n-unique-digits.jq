# Input: an integral decimal number
# Output: the representation of the input in base $b as
# an array of one-character digits, with the least significant digit first.
def tobaseDigits($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  if . == 0 then "0"
  else [digits | digit][:-1]
  end;

def tobase($b):
  tobaseDigits($b) | reverse | add;

# Input: an alphanumeric string to be interpreted as a number in base $b
# Output: the corresponding decimal value
def frombase($b):
  def decimalValue:
    if   48 <= . and . <= 57 then . - 48
    elif 65 <= . and . <= 90 then . - 55  # (10+.-65)
    elif 97 <= . and . <= 122 then . - 87 # (10+.-97)
    else "decimalValue" | error
    end;
  reduce (explode|reverse[]|decimalValue) as $x ({p:1};
    .value += (.p * $x)
    | .p *= $b)
  | .value ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# $n and $base should be decimal integers
def hasallin($n; $base):
  $base == ($n | tobaseDigits($base) | unique | length);

def squaresearch($base):
  def num: "0123456789abcdef";
  (("10" + num[2:$base]) | frombase($base)) as $highest
  | first( range( $highest|sqrt|floor; infinite)  # $highest + 1
           | select(hasallin(.*.; $base)) );

def task:
  "Base       Root N",
  (range(2;16) as $b
  | squaresearch($b)
  | "\($b|lpad(3))  \(tobase($b)|lpad(10) ) \( .*. | tobase($b))" );

task
