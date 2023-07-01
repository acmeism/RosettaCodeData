USE: math.vectors
: accum-left ( seq id quot -- seq ) accumulate nip ; inline
: accum-right ( seq id quot -- seq ) [ <reversed> ] 2dip accum-left <reversed> ; inline
: equilibrium-indices ( seq -- inds )
  0 [ + ] [ accum-left ] [ accum-right ] 3bi [ = ] 2map
  V{ } swap dup length iota [ [ suffix ] curry [ ] if ] 2each ;
