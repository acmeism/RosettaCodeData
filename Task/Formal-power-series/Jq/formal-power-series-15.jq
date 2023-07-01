# Utility functions:

def abs: if . < 0 then -. else . end;

# The power series whose only non-zero coefficient is 1 at x^i:
def ps_at(i): if . ==  i then 1 else 0 end;

# Create an array consisting of the first . coefficients of the power series, p:
def ps_to_array(p): . as $in | reduce range(0;$in) as $i ([]; . + [$i|p]);

def pi: 4 * (1|atan);
