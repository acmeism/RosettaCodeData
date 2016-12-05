# Generic function to count the number of items in a stream:
def count(stream): reduce stream as $i (0; .+1);

def readout:
  . as $sums
  | .[0] as $n
  | reduce range(0;$n) as $i
      ([]; . + [count( $sums[] | select( . > $i) )]);
