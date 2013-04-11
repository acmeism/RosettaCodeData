: limit_example
        15 1 do r> r@ dup rot >r drop \ Bring limit on stack
                . \ And print it
        loop ;
\ Gforth and JSForth all work, SP-Forth brakes (different 'for' implementation?)
