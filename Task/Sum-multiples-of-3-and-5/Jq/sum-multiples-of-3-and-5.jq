def idivide($j):
  (. % $j) as $mod
  | (. - $mod) / $j ;

def sum_multiples(d):
 idivide(d) |  (d * . * (.+1)) | idivide(2)  ;

# Sum of multiples of a or b that are less than . (the input)
def task(a;b):
 . - 1
 | sum_multiples(a) + sum_multiples(b) - sum_multiples(a*b);

# Examples:
(1000 | task(3;5)),  # => 233168

(10e20 | task(3;5)), # => 2.333333333333333e+41

(1000000000000000000000 | task(3;5))
# gojq => 233333333333333333333166666666666666666668
# jq and jaq => 2.333333333333333e41
