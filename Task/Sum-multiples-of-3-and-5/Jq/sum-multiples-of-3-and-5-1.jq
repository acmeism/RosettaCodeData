def sum_multiples(d):
 ((./d) | floor) |  (d * . * (.+1))/2 ;

# Sum of multiples of a or b that are less than . (the input)
def task(a;b):
 . - 1
 | sum_multiples(a) + sum_multiples(b) - sum_multiples(a*b);
