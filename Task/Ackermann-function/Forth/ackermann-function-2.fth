: ackermann                            ( m n -- u )
  over                                 ( case statement)
  0 over = if drop nip 1+     else
  1 over = if drop nip 2 +    else
  2 over = if drop nip 2* 3 + else
  3 over = if drop swap 5 + swap lshift 3 - else
    drop swap 1- swap dup
    if
      1- over 1+ swap recurse recurse exit
    else
      1+ recurse exit                  \ allow tail recursion
    then
  then then then then
;
