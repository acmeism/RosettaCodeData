def run_length_encode:
  explode | runs | reduce .[] as $x (""; . + "\($x[1])\([$x[0]]|implode)");

def run_length_decode:
  reduce (scan( "[0-9]+[A-Z]" )) as $pair
    ( "";
      ($pair[0:-1] | tonumber) as $n
      | $pair[-1:] as $letter
      | . + ($n * $letter)) ;
