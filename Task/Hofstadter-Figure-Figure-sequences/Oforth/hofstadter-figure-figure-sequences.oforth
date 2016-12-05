tvar: R
ListBuffer new 1 over add R put

tvar: S
ListBuffer new 2 over add S put

: buildnext
| r s current i |
   R at ->r
   S at ->s
   r last  r size s at  + dup ->current  r add
   s last 1+  current 1-  for: i [ i s add ]
   current 1+ s add ;

: ffr(n)
   while ( R at size n < ) [ buildnext ]
   n R at at ;

: ffs(n)
   while ( S at size n < ) [ buildnext ]
   n S at at ;
