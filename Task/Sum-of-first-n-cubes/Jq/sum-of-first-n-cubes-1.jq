# For the sake of stream-processing efficiency:
def add(s): reduce s as $x (0; . + $x);

def sum_of_cubes: add(range(0;.) | .*.*.);
