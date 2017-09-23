# 15-bit integers generated using the same formula as rand() from the Microsoft C Runtime.
# The random numbers are in [0 -- 32767] inclusive.
# Input: an array of length at least 2 interpreted as [count, state, ...]
# Output: [count+1, newstate, r] where r is the next pseudo-random number.
def next_rand_Microsoft:
  .[0] as $count | .[1] as $state
  | ( (214013 * $state) + 2531011) % 2147483648 # mod 2^31
  | [$count+1 , ., (. / 65536 | floor) ] ;
