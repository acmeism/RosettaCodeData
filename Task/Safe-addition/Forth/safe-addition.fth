c-library m
s" m" add-lib
\c #include <math.h>
c-function fnextafter nextafter r r -- r
end-c-library

s" MAX-FLOAT" environment? drop fconstant MAX-FLOAT

: fstepdown ( F: r1 -- r2 )
   MAX-FLOAT fnegate fnextafter ;
: fstepup ( F: r1 -- r2 )
   MAX-FLOAT fnextafter ;

: savef+ ( F: r1 r2 -- r3 r4 ) \ r4 <= r1+r2 <= r3
   f+  fdup fstepup  fswap fstepdown ;
