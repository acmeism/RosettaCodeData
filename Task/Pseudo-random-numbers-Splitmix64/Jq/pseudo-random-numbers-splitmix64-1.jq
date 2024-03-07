# Input: a string in base $b (2 to 35 inclusive)
# Output: a JSON number, being the decimal value corresponding to the input.
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

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# If the input and $j are integers, then the result will be an integer.
def div($j):
  (. - (. % j)) / $j;

# Convert an integer to a bitarray, least significant bit first
def bitwise:
  recurse( if . >= 2 then div(2) else empty end) | . % 2;

# Essentially the inverse of bitwise,
# i.e. interpret an array of 0s and 1s (with least-significant-bit first ) as a decimal
def to_int:
  . as $in
  # state: [sum, power]
  | reduce .[] as $i ([0, 1]; .[1] as $p | [.[0] + $p * $i, ($p * 2)])
  | .[0];

# $x and $y and output are bitarrays
def xor($x;$y):
   def lxor(a;b):
     if (a==1 or b==1) and ((a==1 and b==1)|not) then 1
     elif a == null then b
     elif b == null then a
     else 0
     end;
   if $x == [0] then $y
   elif $y == [0] then $x
   else
     [ range(0; [($x|length), ($y|length)] | max) as $i
       | lxor($x[$i]; $y[$i]) ]
   end ;

# $x and $y and output are bitarrays
def xand($x;$y):
   def lxand(a;b):
      (a==1 and b==1) | 1 // 0;
   if $x == [0] or $y == [0] then [0]
   else
     [range(0; [($x|length), ($y|length)] | min) as $i
      | lxand($x[$i]; $y[$i]) ]
   end ;

# shift right
def right($n): .[$n:];

def mask64: .[:64];

# input and output: a bitarray
def mult($int):
  ($int * to_int) | [bitwise];

def plus($int):
  ($int + to_int) | [bitwise];

def tabulate(stream):
  reduce stream as $i ([]; .[$i] += 1)
  | range(0;length) as $i
  | " \($i) :  \(.[$i] // 0)" ;
