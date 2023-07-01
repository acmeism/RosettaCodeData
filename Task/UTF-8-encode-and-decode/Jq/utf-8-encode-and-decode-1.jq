# input: a decimal integer
# output: the corresponding binary array, most significant bit first
def binary_digits:
  if . == 0 then 0
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2]
    | reverse
    | .[1:] # remove the leading 0
  end ;

# Input: an array of binary digits, msb first.
def binary_to_decimal:
  reduce reverse[] as $b ({power:1, result:0};
       .result += .power * $b
       | .power *= 2)
  | .result;
