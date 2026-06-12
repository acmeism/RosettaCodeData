variable bitsbuff

: alphabase ( u -- c ) $3F and C" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" 1+ + c@ ;
: storecode ( u f -- ) if drop '=' else alphabase then c, ;

: 3bytesin ( addrf addr -- n )
   $0 bitsbuff !
   3 0 do
      dup I + c@ bitsbuff @ 8 lshift + bitsbuff !
   loop
   -
;

: 4chars, ( n -- ) ( n=# of bytes )
   4 0 do
      dup I - 0<
      bitsbuff @ 18 rshift swap storecode
      bitsbuff @ 6 lshift bitsbuff !
   loop drop
;

: b64enc ( addr1 n1 -- addr2 n2 )
   here rot rot      ( addr2 addr1 n1 )
   over + dup rot    ( addr2 addr1+n1 addr1+n1 addr1 )
   do
      dup I 3bytesin 4chars,
   3 +loop drop      ( addr2 )
   dup here swap -   ( addr2 n2 )
;
