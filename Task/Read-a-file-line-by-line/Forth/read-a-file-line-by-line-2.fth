: read-lines' ( filename-addr filename-len -- )
  r/o open-file throw ( buffer-len wfileid )
  over 2 +  \ Add space for up to two line terminators after the buffer.
  allocate throw  ( buffer-len wfileid buffer-addr )
  -rot 2>r ( buffer-addr )
  begin
    dup 2r@ read-line throw  ( buffer bytes-read flag )
  while
      ( buffer-addr bytes-read )
      over swap type cr
  repeat
  drop free throw
  2r> close-file throw  drop ;

4096 s" infile.txt" read-lines'
