eq=: -:                         NB. equal
ne=: -.@-:                      NB. not equal
gt=: {.@/:@,&boxopen *. ne      NB. lexically greater than
lt=: -.@{.@/:@,&boxopen *. ne   NB. lexically less than
ge=: {.@/:@,&boxopen +. eq      NB. lexically greater than or equal to
le=: -.@{.@/:@,&boxopen         NB. lexically less than or equal to
