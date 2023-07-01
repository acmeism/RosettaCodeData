# Apply g first
def compose(f; g): g | f;

def A: [sin, cos, .*.*.];

def B: [asin, acos, pow(.; 1/3) ];

0.5
| range(0;3) as $i
| compose( A[$i]; B[$i] )
