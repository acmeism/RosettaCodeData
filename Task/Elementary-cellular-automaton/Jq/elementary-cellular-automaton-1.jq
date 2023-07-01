# The ordinal value of the relevant states:
def states:
  {"111": 1, "110": 2, "101": 3, "100": 4, "011": 5, "010": 6, "001": 7, "000": 8};

# Compute the next "state"
# input: a state ("111" or "110" ...)
# rule: the rule represented as a string of 0s and 1s
# output: the next state "0" or "1" depending on the rule
def next(rule):
  states[.] as $n | rule[($n-1):$n] ;

# The state of cell $n, using 0-based indexing
def triple($n):
  if $n == 0 then .[-1:] + .[0:2]
  elif $n == (length-1) then .[-2:] + .[0:1]
  else .[$n-1:$n+2]
  end;

# input: non-negative decimal integer
# output: 0-1 binary string
def binary_digits:
  if . == 0 then "0"
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2 | tostring]
    | reverse
    | .[1:] # remove the leading 0
    | join("")
  end ;
