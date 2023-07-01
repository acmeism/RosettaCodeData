USING: kernel math math.functions math.ranges prettyprint
sequences ;

: non-sq ( n -- m ) dup sqrt 1/2 + floor + >integer ;

: print-first22 ( -- ) 22 [1,b] [ non-sq ] map . ;

: check-for-sq ( -- ) 1,000,000 [1,b)
    [ non-sq sqrt dup floor = [ "Square found." throw ] when ]
    each ;

print-first22 check-for-sq
