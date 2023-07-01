# 15-bit integers generated using the same formula as rand()
# from the Microsoft C Runtime.
# Input: [ count, state, rand ]
def next_rand_Microsoft:
  .[0] as $count | .[1] as $state
  | ( (214013 * $state) + 2531011) % 2147483648 # mod 2^31
  | [$count+1 , ., (. / 65536 | floor) ];

def rand_Microsoft(seed):
  [0,seed]
  | next_rand_Microsoft  # the seed is not so random
  | recurse( next_rand_Microsoft )
  | .[2];

# Generate random integers from 0 to (n-1):
def rand(n): n * (rand_Microsoft(17) / 32768) | trunc;
