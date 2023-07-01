# SIGMA(exp) computes the sum of exp over the input array:
def SIGMA(exp): map(exp) | add;

# SIGMA(exp; S) computes the sum of exp over elements of the stream, S,
# without creating an intermediate array:
def SIGMA(exp; S): reduce (S|exp) as $x (0; . + $x);
