: st-count ( stats -- n )                f@ ;
: st-mean  ( stats -- mean )    float+   f@ ;
: st-nvar  ( stats -- n*var ) 2 floats + f@ ;

: st-variance ( stats -- var ) dup st-nvar st-count f/ ;
: st-stddev ( stats -- stddev ) st-variance fsqrt ;

: st-add ( x stats -- )
  dup
  1e dup f+!			\ update count
  fdup dup st-mean f- fswap
  ( delta x )
  fover dup st-count f/
  ( delta x delta/n )
  float+ dup f+!		\ update mean
  ( delta x )
  dup f@ f-  f*  float+ f+!	\ update nvar
  st-stddev ;
