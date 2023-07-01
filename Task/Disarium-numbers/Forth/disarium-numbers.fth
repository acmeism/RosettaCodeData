: pow 1 swap 0 ?do over * loop nip ;
: len 1 swap begin dup 10 >= while 10 / swap 1+ swap repeat drop ;

: dps 0 swap dup len
  begin dup while
    swap 10 /mod swap
    2 pick pow
    3 roll +
    rot 1- rot
    swap
  repeat
  2drop
;

: disarium dup dps = ;
: disaria 2700000 0 ?do i disarium if i . cr then loop ;

disaria
bye
