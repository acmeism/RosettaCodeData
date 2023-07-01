\ this is congruent to the previous demonstration, employing
\ a data structure to store goto/jump addresses instead of
\ separate variables, and two additional words 'mark_goto' and
\ 'goto'. works with ficl, pfe, gforth, bigforth, and vfxforth.
\ swiftforth and iforth crash.

create gotos 10 cells allot  \ data structure for storing goto/jump addresses
: mark_goto here swap 1- cells gotos + ! ; immediate  \ save addresses for jumping
: goto  r> drop 1- cells gotos + @ >r ;

\ designations for commands are immaterial when using goto's,
\ since the commands are not referenced by name, and are instead
\ jumped into by means of the goto marker.

: command1
[ 1 ] mark_goto s" item1 " type 7 goto
[ 2 ] mark_goto s" item2 " type 8 goto
[ 3 ] mark_goto s" item3 " type 9 goto
[ 4 ] mark_goto s" item4 " type 10 goto
[ 5 ] mark_goto s" item5 " type cr 2dup = if 2drop exit then 1+ 6 goto ;

: command2
[ 6 ] mark_goto s" line " type dup . s" --> item6 " type 1 goto
[ 7 ] mark_goto s" item7 " type 2 goto
[ 8 ] mark_goto s" item8 " type 3 goto
[ 9 ] mark_goto s" item9 " type 4 goto
[ 10 ] mark_goto s" item10 " type 5 goto ;

: go 5 1 6 goto ; go
bye
