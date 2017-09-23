# Compute self^m where m is a non-negative integer:
def pow(m): . as $in | reduce range(0;m) as $i (1; .*$in);

# state: [i, i^m]
def next_power(m): .[0] + 1 | [., pow(m) ];
