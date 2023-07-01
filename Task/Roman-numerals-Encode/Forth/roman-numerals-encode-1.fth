: vector create ( n -- ) 0 do , loop  does>  ( n -- ) swap cells + @ execute ;
\ these are ( numerals -- numerals )
: ,I  dup c@ C, ;  : ,V  dup 1 + c@ C, ;  : ,X  dup 2 + c@ C, ;

\ these are ( numerals -- )
:noname  ,I ,X     drop ;   :noname  ,V ,I ,I ,I  drop ;   :noname  ,V ,I ,I  drop ;
:noname  ,V ,I     drop ;   :noname  ,V           drop ;   :noname  ,I ,V     drop ;
:noname  ,I ,I ,I  drop ;   :noname  ,I ,I        drop ;   :noname  ,I        drop ;
' drop ( 0 : no output )  10 vector ,digit
	
: roman-rec ( numerals n -- )  10 /mod dup if >r over 2 + r> recurse else drop then ,digit ;
: roman ( n -- c-addr u )
  dup 0 4000 within 0= abort" EX LIMITO!"
  HERE SWAP  s" IVXLCDM" drop swap roman-rec  HERE OVER - ;

1999 roman type     \ MCMXCIX
  25 roman type     \ XXV
 944 roman type     \ CMXLIV
