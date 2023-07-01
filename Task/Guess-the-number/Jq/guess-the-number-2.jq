# LCG::Microsoft generates 15-bit integers using the same formula
# as rand() from the Microsoft C Runtime.
# Input: [ count, state, random ]
def next_rand_Microsoft:
  .[0] as $count
  | ((214013 * .[1]) + 2531011) % 2147483648 # mod 2^31
  | [$count+1 , ., (. / 65536 | floor) ];

def rand_Microsoft(seed):
  [0,seed]
  | next_rand_Microsoft  # the seed is not so random
  | next_rand_Microsoft | .[2];

# A random integer in [0 ... (n-1)]:
def rand(n): n * (rand_Microsoft($seed|tonumber) / 32768) | trunc;
