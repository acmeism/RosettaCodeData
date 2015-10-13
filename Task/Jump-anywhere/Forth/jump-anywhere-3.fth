create gotos 11 cells allot  \ data structure consisting of 10 cells for
                             \ storing addrs of goto markers/labels.
                             \ 11 cells are allocated, with the 1st cell
                             \ unused, for the offset would be 0. to begin
                             \ counting from 1, the offset of the 2nd cell,
                             \ is easier to remember. this is merely a preference.
                             \ if additional goto markers are needed, merely
                             \ increase the quantity of cells in this data structure.

: mark_goto here swap cells gotos + ! ; immediate  \ position (offset) of cell within
                                                   \ data structure must be on stack.

: goto  r> drop  cells gotos + @ >r  exit ;  \ "exit" is needed for iforth only.
                                             \ position (offset) of cell within
                                             \ data structure must be on stack.

\ designations for commands are immaterial when using goto's,
\ since the commands are not referenced by name, and are instead
\ jumped into by means of the goto marker.

: command1
[ 1 ] mark_goto s" line1 " type 7 goto
[ 2 ] mark_goto s" line2 " type 8 goto
[ 3 ] mark_goto s" line3 " type 9 goto
[ 4 ] mark_goto s" line4 " type 10 goto
[ 5 ] mark_goto s" line5" type cr bye ;

: command2
[ 6 ] mark_goto s" line6 " type 1 goto
[ 7 ] mark_goto s" line7 " type 2 goto
[ 8 ] mark_goto s" line8 " type 3 goto
[ 9 ] mark_goto s" line9 " type 4 goto
[ 10 ] mark_goto s" line10 " type 5 goto ;

: go 6 goto ; go
