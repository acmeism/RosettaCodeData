: f+! ( x addr -- ) dup f@ f+ f! ;

: st-count ( stats -- n )                  f@ ;
: st-sum   ( stats -- sum )       float+   f@ ;
: st-sumsq ( stats -- sum*sum ) 2 floats + f@ ;

: st-mean ( stats -- mean )
  dup st-sum st-count f/ ;

: st-variance ( stats -- var )
  dup st-sumsq
  dup st-mean fdup f* dup st-count f*  f-
  st-count f/ ;

: st-stddev ( stats -- stddev )
  st-variance fsqrt ;

: st-add ( fnum stats -- )
  dup
    1e dup f+!  float+
  fdup dup f+!  float+
  fdup f*  f+!
  std-stddev ;
