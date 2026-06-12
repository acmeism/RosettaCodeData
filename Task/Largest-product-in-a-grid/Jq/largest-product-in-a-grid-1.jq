def prod(s): reduce s as $x (1; . * $x);
def prod: prod(.[]);

# Input: an array
# Output: a stream of arrays
def windows($size): range(0; 1+length-$size) as $i | .[$i:$i+$size];
