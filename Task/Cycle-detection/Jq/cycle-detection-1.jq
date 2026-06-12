def floyd(f; x0):
   {tort: (x0|f)}
   | .hare = (.tort|f)
   | until( .tort == .hare;
        .tort |= f
        | .hare |= (f|f) )
   | .mu = 0
   | .tort = x0
   | until( .tort == .hare;
        .tort |= f
        | .hare |= f
        | .mu += 1)
   | .lambda = 1
   | .hare = (.tort|f)
   | until (.tort == .hare;
        .hare |= f
        | .lambda += 1 )
   | {lambda, mu} ;

def task(f; x0):
  def skip($n; stream):
    foreach stream as $s (0; .+1; select(. > $n) | $s);

  floyd(f; x0)
  | .,
    "Cycle:",
    skip(.mu; limit((.lambda + .mu); 3 | recurse(f)));
