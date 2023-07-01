-0.             . ! -0.0  literal negative zero
 0. neg         . ! -0.0  neg works with floating point zeros
 0. -1. *       . ! -0.0  calculating negative zero
 1/0.           . !  1/0. literal positive infinity
 1e3 1e3 ^      . !  1/0. calculating positive infinity
-1/0.           . ! -1/0. literal negative infinity
-1. 1e3 1e3 ^ * . ! -1/0. calculating negative infinity
-1/0. neg       . !  1/0. neg works with the inifinites
 0/0.           . !  NAN: 8000000000000 literal NaN, configurable with
                  !                     arbitrary 64-bit hex payload
 1/0. 1/0. -    . !  NAN: 8000000000000 calculating NaN by subtracting
                  !                     infinity from infinity
