def key:
  "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ";

def encode:
  (key|explode) as $key
  | explode as $exploded
  | reduce range(0;length) as $i ([];
        . + [$key[ $exploded[$i] - 32]] )
  | implode;

def decode:
  (key|explode) as $key
  | explode as $exploded
  | reduce range(0;length) as $i ([];
       $exploded[$i] as $c
       | . + [ $key | index($c) + 32] )
  | implode ;

def task:
  "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
   | encode as $encoded
   |"Encoded:  \($encoded)",
    "Decoded:  \($encoded|decode)" ;

task
