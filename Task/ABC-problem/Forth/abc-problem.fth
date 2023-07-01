: blockslist s" BOXKDQCPNAGTRETGQDFSJWHUVIANOBERFSLYPCZM" ;
variable blocks
: allotblocks ( -- ) here blockslist dup allot here over - swap move blocks ! ;
: freeblocks blockslist nip negate allot ;
: toupper 223 and ;

: clearblock ( addr-block -- )
dup '_' swap c!
dup blocks @ - 1 and if 1- else 1+ then
'_' swap c!
;

: pickblock ( addr-input -- addr-input+1 f )
dup 1+ swap c@ toupper    ( -- addr-input+1 c )
blockslist nip 0 do
  blocks @ i + dup c@ 2 pick       ( -- addr-input+1 c addri ci c )
  = if clearblock drop true unloop exit else drop then
loop drop false
;

: abc ( addr-input u -- f )
allotblocks
0 do
  pickblock
  invert if drop false unloop exit cr then
loop drop true
freeblocks
;

: .abc abc if ." True" else ." False" then ;
