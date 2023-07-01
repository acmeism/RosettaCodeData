: semiprime?
  0 swap dup 2 do
    begin dup i mod 0= while i / swap 1+ swap repeat
    over 1 > over i dup * < or if leave then
  loop 1 > abs + 2 =
;

: test 100 2 do i semiprime? if i . then loop cr ;
