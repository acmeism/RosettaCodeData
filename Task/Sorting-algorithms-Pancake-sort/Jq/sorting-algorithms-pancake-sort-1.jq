def pancakeSort:

  def flip(i):
    . as $in | ($in[0:i+1]|reverse) + $in[i+1:] ;

  # If input is [] then return null
  def index_of_max:
    . as $in
    | reduce range(1; length) as $i
        # state: [ix, max]
        ( [ 0, $in[0] ];
          if $in[$i] > .[1] then [ $i, $in[$i] ] else . end )
    | .[0] ;

  reduce range(0; length) as $iup
    (.;
     (length - $iup - 1) as $i
     | (.[0:$i+1] | index_of_max) as $max
     # flip about $max and then about $i unless $i == $max
     | if ($i == $max) then .
       else flip($max) | flip($i)
       end ) ;
