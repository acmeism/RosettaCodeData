import "BigInt" as BigInt;

# integer input
def long_left_factorial:
  reduce range(1; .+1) as $i
  # state: [i!, !i]
    ( ["1", "0"];
      .[1] = BigInt::long_add(.[0]; .[1])
    | .[0] = BigInt::long_multiply(.[0]; $i | tostring) )
  | .[1];

# input and gap should be integers
def long_left_factorial_lengths(gap):
  reduce range(1; .+1) as $i
  # state: [i!, !i, gap]
    (["1", "0", []];
    .[1] = BigInt::long_add(.[0]; .[1])
    | .[0] = BigInt::long_multiply(.[0]; $i|tostring)
    | (.[1] | tostring | length) as $lf
    | if $i % gap == 0 then .[2] += [[$i, $lf]] else . end)
  | .[2];
