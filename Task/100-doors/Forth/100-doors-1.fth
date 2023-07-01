: toggle ( c-addr -- )  \ toggle the byte at c-addr
    dup c@ 1 xor swap c! ;

100  1+ ( 1-based indexing ) constant ndoors
create doors  ndoors allot

: init ( -- )  doors ndoors erase ;  \ close all doors

: pass ( n -- )  \ toggle every nth door
    ndoors over do
        doors i + toggle
    dup ( n ) +loop drop ;

: run ( -- )  ndoors 1 do  i pass  loop ;
: display ( -- )  \ display open doors
    ndoors 1 do  doors i + c@ if  i .  then loop cr ;

init run display
