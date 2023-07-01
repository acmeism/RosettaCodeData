[hex] 362 [decimal] 4TH# - [if] [abort] [then]

-32 value bloop
[defined] bloop [if]
  [defined] abs [if]
     bloop abs . cr
  [then]
[then]

0 last cell+ first over over - .( User variables: ) .
?do i @ + loop .( Sum: ) . cr
