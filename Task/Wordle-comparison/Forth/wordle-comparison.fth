: color! ( c i -- ) tuck pad + c! here + 0 swap c! ;

: wordle ( a1 u1 a2 u2 -- a3 u3 )
   2swap here swap move pad over erase dup 0 do
      over i + c@ here i + c@ = if 2 i color! then
   loop dup 0 do
      2dup here swap rot i + 1 search nip nip if 1 i color! then
   loop nip pad swap ;

:noname
   create s" grey" , , s" yellow" , , s" green" , ,
   does> swap 2* cells + 2@ type ; execute color.

: .wordle ( a1 u1 a2 u2 -- )
   2over type ."  v " 2dup type ."  => " wordle
   over + swap do i c@ color. space loop cr ;

:noname
   0 s" ROBIN" 2dup 2dup s" SONIC" 2over s" ALERT"
   s" BULLY" s" LOLLY" s" ALLOW" 2over
   begin ?dup while .wordle repeat ; execute
