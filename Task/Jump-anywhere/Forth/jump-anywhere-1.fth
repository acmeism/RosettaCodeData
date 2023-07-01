\ this prints five lines containing elements from the two
\ words 'proc1' and 'proc2'. gotos are used here to jump
\ into and out of the two words at various points, as well
\ as to create a loop. this functions with ficl, pfe,
\ gforth, bigforth, swiftforth, iforth, and vfxforth; it
\ may work with other forths as well.

create goto1 1 cells allot create goto2 1 cells allot
create goto3 1 cells allot create goto4 1 cells allot
create goto5 1 cells allot create goto6 1 cells allot
create goto7 1 cells allot create goto8 1 cells allot
create goto9 1 cells allot create goto10 1 cells allot

: proc1
[ here goto1 ! ] s" item1 " type goto7 @ >r exit
[ here goto2 ! ] s" item2 " type goto8 @ >r exit
[ here goto3 ! ] s" item3 " type goto9 @ >r exit
[ here goto4 ! ] s" item4 " type goto10 @ >r exit
[ here goto5 ! ] s" item5" type cr 2dup = if 2drop exit then 1+ goto6 @ >r ;

: proc2
[ here goto6 ! ] s" line " type dup . s" --> item6 " type goto1 @ >r exit
[ here goto7 ! ] s" item7 " type goto2 @ >r exit
[ here goto8 ! ] s" item8 " type goto3 @ >r exit
[ here goto9 ! ] s" item9 " type goto4 @ >r exit
[ here goto10 ! ] s" item10 " type goto5 @ >r ;

5 1 proc2
bye
