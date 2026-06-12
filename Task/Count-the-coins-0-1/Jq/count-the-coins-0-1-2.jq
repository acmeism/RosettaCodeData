## Generic helper functions:
def count(s): reduce s as $x (0; .+1);

# Input: an array [a, b, ... ]
# Output: [ [a,0], [b,0],... ] | combinations
def zero_or_one: [ .[] | [., 0] ] | combinations;
