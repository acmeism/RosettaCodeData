s" ps " system                                 \ Output  only
                                 \ read via pipe  into buffer
create buffer 266 allot
s" ps " r/o open-pipe   throw
dup buffer swap  256 swap
read-file throw
swap close-pipe throw drop

buffer swap  type          \ output  is the  same  like  above
