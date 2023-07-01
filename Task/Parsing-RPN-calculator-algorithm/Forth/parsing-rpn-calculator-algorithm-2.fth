: ^ over swap 1 ?do over * loop nip ;
: detail
  begin
    cr ." stack: " .s
    bl word count dup
  0<> while
    ." , read: " 2dup type evaluate
  repeat
  2drop
;
detail 3 4 2 * 1 5 - 2 3 ^ ^ / +
