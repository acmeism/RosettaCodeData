USING: combinators.random io kernel math math.order prettyprint ;

: position (     -- n   ) 0 ;
: stairs   (     -- n   ) 100 ;
: new      (     -- m n ) position stairs ;
: incd     ( m n -- o p ) swap 1 + swap ;
: seconds  ( m   -- n   ) 100 - 5 / ;
: window?  ( n   -- ?   ) seconds 600 609 between? ;
: zap      ( m n -- o p ) 2dup / [ incd ] whenp 1 + ;
: barrage  ( m n -- o p ) 5 [ zap ] times ;
: .n       ( n   --     ) pprint 7 [ bl ] times ;
: .stats   ( m n --     ) dup seconds .n over .n swap - .n nl ;
: .header  (     --     ) "Seconds  behind     ahead" print ;
: ?.status ( m n -- o p ) dup window? [ 2dup .stats ] when ;
: tick     ( m n -- o p ) incd barrage ;
: demo     ( m n -- o p ) tick ?.status ;
: sim-with ( q   -- n   ) new rot [ 2dup < ] swap while drop ; inline
: first    (     -- n   ) [ demo ] sim-with ;
: sim      (     -- n   ) [ tick ] sim-with ;
: sims     (     -- n   ) 0 first + 9999 [ sim + ] times ;
: steps    ( m   -- n   ) "Avg. steps: " write 10000 / dup . ;
: time     ( n   --     ) "Avg. seconds: " write seconds . ;
: main     (     --     ) .header sims nl steps time ;

main
