: bottles ( n -- ) \ select the right grammar based on 'n'
        dup
        case
         1 of    ." One more bottle " drop endof
         0 of    ." No more bottles " drop endof
                 . ." bottles "    \ default case
        endcase ;

\ create punctuation with delay for artistic effect
: ,   [char] , emit  100 ms ;
: .   [char] . emit  300 ms ;

\ create the words to write the program
: of       ." of "   ;
: beer     ." beer " ;
: on       ." on "   ;
: the      ." the "  ;
: wall     ." wall" ;
: take     ." take " ;
: one      ." one "  ;
: down     ." down" ;
: pass     ."  pass " ;
: it       ." it "   ;
: around   ." around" ;

\ who said Forth is write only?
: beers ( n -- )   \  USAGE:  99 beers
      1 swap
      cr
      do
           I bottles of beer on the wall , cr
           I bottles of beer ,             cr
             take one down , pass it around , cr
        I 1- bottles of beer on the wall .  cr
        cr
      -1 +loop ;
