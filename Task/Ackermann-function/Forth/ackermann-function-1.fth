: acker ( m n -- u )
	over 0= IF  nip 1+ EXIT  THEN
	swap 1- swap ( m-1 n -- )
	dup  0= IF  1+  recurse EXIT  THEN
	1- over 1+ swap recurse recurse ;
