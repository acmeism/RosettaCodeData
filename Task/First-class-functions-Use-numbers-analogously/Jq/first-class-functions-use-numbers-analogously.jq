# Infrastructure:
# zip this and that
def zip(that): [., that] | transpose;

# The task:
def x:  2.0;
def xi: 0.5;
def y:  4.0;
def yi: 0.25;
def z:  x + y;
def zi: 1.0 / (x + y);

def numlist: [x,y,z];

def invlist: [xi, yi, zi];

# Input: [x,y]
def multiplier(j): .[0] * .[1] * j;

numlist | zip(invlist) | map( multiplier(0.5) )
