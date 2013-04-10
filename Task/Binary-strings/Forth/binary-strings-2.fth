: empty? ( str len -- ? ) nip 0= ;
: +c ( c str len -- ) + c! ;
: replace-bytes ( from to str len -- )
  bounds do
    over i c@ = if dup i c! then
  loop 2drop ;
