variable bitsbuff

: char>6bits ( c -- u )
   dup 43 =          if drop 62   exit then    ( + case )
   dup 47 =          if drop 63   exit then    ( / case )
   dup 48 58 within  if 48 - 52 + exit then    ( 0-9 case )
   dup 65 91 within  if 65 -      exit then    ( A-Z case )
   dup 97 123 within if 97 - 26 + exit then    ( a-z case )
   drop 0                                      ( padding )
;
: 6bitsin ( v -- ) bitsbuff @ 6 lshift + bitsbuff ! ;
: 4charsin ( addr -- addr+4 )
   $0 bitsbuff !
   dup 4 + dup rot
   do I c@ char>6bits 6bitsin loop ;
: 3bytes, ( -- )
   bitsbuff @ 16 rshift $ff and c,
   bitsbuff @  8 rshift $ff and c,
   bitsbuff @           $ff and c, ;


: b64dec ( addr1 n1 -- addr2 n2 )
   here rot rot ( addr2 addr1 n1 )
   4 /          ( addr2 addr1 n1/4 )
   0 do
      4charsin 3bytes,
   loop                                   ( addr2 addr1+4x )
   ( get back for padding )
   1 - dup c@ 61 = if 1 else 0 then swap  ( addr2 0|1 addr1+4x-1 )
   1 -     c@ 61 = if 1 else 0 then +     ( addr2 0|1|2 )
   swap            ( 0|1|2 addr2 )
   dup here swap - ( 0|1|2 addr2 n' )
   rot -           ( addr2 n2 )
;
