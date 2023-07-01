: map ( addr n fn -- )
   -rot cells bounds do  i @ over execute i !  cell +loop ;
