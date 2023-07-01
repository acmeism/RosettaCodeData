def cholesky_factor:
  if is_symmetric then
    length as $length
    | . as $self
    | reduce range(0; $length) as $k
        ( matrix(length; length; 0); # the matrix that will hold the answer
          reduce range(0; $length) as $i
            (.;
             if $i == $k
               then (. as $lower
                     | reduce range(0; $k) as $j
                         (0; . + ($lower[$k][$j] | .*.) )) as $sum
                 | .[$k][$k] = (($self[$k][$k] - $sum) | sqrt)
             elif $i > $k
               then (. as $lower
                     | reduce range(0; $k) as $j
                         (0; . + $lower[$i][$j] * $lower[$k][$j])) as $sum
                 | .[$i][$k] = (($self[$k][$i] - $sum) / .[$k][$k] )
             else .
             end ))
  else error( "cholesky_factor: matrix is not symmetric" )
  end ;
