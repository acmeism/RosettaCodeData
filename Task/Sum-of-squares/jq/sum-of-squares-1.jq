# ss for an input array:
def ss: map(.*.) | add;

# ss for a stream, S, without creating an intermediate array:
def ss(S): reduce S as $x (0; . + ($x * $x) );
