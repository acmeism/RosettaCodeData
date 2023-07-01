# "VARIABLE-LENGTH QUANTITY"
# A VLQ is a variable-length encoding of a number into a sequence of octets,
# with the most-significant octet first, and with the most significant bit first in each octet.
# The first (left-most) bit in each octet is a continuation bit: all octets except the last have the left-most bit set.
# The bits of the original number are taken 7 at a time from the right to form the octets.
# Thus, if the number is between 0 and 127, it is represented exactly as one byte.

# Produce a stream of the base $b "digits" of the input number,
# least significant first, with a final 0
def digits($b):
  def mod: . % $b;
  def div: ((. - mod) / $b);
  recurse( select(. > 0) | div) | mod ;

# 2 <= $b <= 36
def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  if . == 0 then "0"
  else [digits($b) | digit] | reverse[1:] | add
  end;

# input: a decimal integer
# output: the corresponding variable-length quantity expressed as an array of strings of length 2,
# each representing an octet in hexadecimal notation, with most-significant octet first.
def vlq:
  def lpad: if length == 2 then . else "0" + . end;
  [digits(128) + 128] | reverse[1:] | .[-1] -=128 | map(tobase(16) | lpad);

# Input: a VLQ as produced by vlq/0
# Output: the corresponding decimal
def vlq2dec:
  def x2d:   # convert the character interpreted as a hex digit to a decimal
    explode[0] as $x
    | if $x < 65 then $x - 48 elif $x < 97 then $x - 55 else $x - 87 end;
  map( ((.[0:1] | x2d) * 16) + (.[1:] | x2d) - 128)
  | .[-1] += 128  # the most significant bit of the least significant octet
  | reduce reverse[] as $x ({x: 0, m: 1}; .x += ($x * .m) | .m *= 128)
  | .x ;

# The task

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

2097152, 2097151
| vlq as $vlq
| "\(lpad(8)) => \($vlq|join(",")|lpad(12)) => \($vlq | vlq2dec | lpad(8))"
