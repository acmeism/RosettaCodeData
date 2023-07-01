#! /usr/bin/gforth -d 20M
\ Abelian Sandpile Model

0 assert-level !

\ command-line

: parse-number  s>number? invert throw drop ;
: parse-size    ." size  : " next-arg parse-number dup . cr ;
: parse-height  ." height: " next-arg parse-number dup . cr ;
: parse-args    cr parse-size parse-height ;

parse-args constant HEIGHT constant SIZE

: allot-erase   create here >r dup allot r> swap erase ;
: size^2        SIZE dup * cells ;
: 2cells        [ 2 cells ] literal ;
: -2cells       [ 2cells negate ] literal ;

size^2 allot-erase arr

\ array processing
: ix            swap SIZE * + cells arr + ;
: center        SIZE 2/ dup ;
: write-cell    ix @ u. ;
: write-row     SIZE 0 ?do dup i write-cell loop drop cr ;
: arr.          SIZE 0 ?do i write-row loop ;

\ stack processing

: stack-empty?  dup -1 = ;
: stack-full?   stack-empty? invert ;

\ pgm-handling

: concat        { a1 l1 a2 l2 } l1 l2 + allocate throw dup dup a1 swap l1 cmove a2 swap l1 + l2 cmove l1 l2 + ;
: write-pgm     ." P2" cr SIZE u. SIZE u. cr ." 3" cr arr. ;
: u>s           0 <# #s #> ;
: filename      s" sandpile-" SIZE u>s concat s" -" concat HEIGHT u>s concat s" .pgm" concat ;
: to-pgm        filename w/o create-file throw ['] write-pgm over outfile-execute close-file throw ;

\ sandpile

: prep-arr      HEIGHT center ix ! ;
: prep-stack    -1 HEIGHT 4 u>= if center then ;
: prepare       prep-arr prep-stack ;
: ensure        if else 2drop 0 2rdrop exit then ;
: col>=0        dup 0>= ensure ;
: col<SIZE      dup SIZE < ensure ;
: row>=0        over 0>= ensure ;
: row<SIZE      over SIZE < ensure ;
: legal?        col>=0 col<SIZE row>=0 row<SIZE 2drop true ;
: north         1. d- ;
: east          1+ ;
: south         1. d+ ;
: west          1- ;
: reduce        2dup ix dup -4 swap +! @ 4 < if 2drop then ;
: increase      2dup legal? if 2dup ix dup 1 swap +! @ 4 = if 2swap else 2drop then else 2drop then ;
: inc-north     2dup north increase ;
: inc-east      2dup east increase ;
: inc-south     2dup south increase ;
: inc-west      2dup west increase ;
: inc-all       inc-north inc-east inc-south inc-west 2drop ;
: simulate      prepare begin stack-full? while 2dup 2>r reduce 2r> inc-all repeat drop to-pgm ." written to " filename type cr ;

simulate bye
