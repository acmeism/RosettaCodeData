def is_prime:
  if  . == 2 then true
  else
     2 < . and . % 2 == 1 and
       (. as $in
       | (($in + 1) | sqrt) as $m
       | [false, 3] | until( .[0] or .[1] > $m; [$in % .[1] == 0, .[1] + 2])
       | .[0]
       | not)
  end ;

range(3;6000) | select( all( .-1, .+3, .+5; is_prime))
