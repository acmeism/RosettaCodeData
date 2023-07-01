# BSD rand()
# Input: [count, previous]
def next_rand_berkeley:
  long_multiply("1103515245" ; .[1]|tostring) as $lm
  | long_add( $lm; "12345") as $la
  # mod 2^31
  | [.[0] + 1, (long_mod( $la; "2147483648") | tonumber) ];

# Generate n values
def rand_berkeley(seed; n):
  [0, seed]
  | next_rand_berkeley # skip the seed itself
  | recurse(if .[0] < n then next_rand_berkeley else empty end)
  | .[1];
