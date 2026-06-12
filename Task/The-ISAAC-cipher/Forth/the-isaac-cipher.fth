Tested for VFX Forth and GForth 64bit in Linux
The code was based on and debugged v python

\ *******     Words for 32 bit fetching and storing     *******
\ * Implement words for 32 bit fields (assuming 64 bit Forth) *
\ *************************************************************

: halves 4 * ;   \ half a cell.

\ VFX Forth
\ : h@   L@ ;  : h!   L! ;   : h+!   L+! ;
\  GFORTH
: h@  UL@ ;  : h!   L! ;  : h+!  DUP h@ ROT + SWAP h! ;
\ a 32 bit Forth
\ : h@ @ ; : h! ! ;   : h+!  +! ;

: half-array   \ n <'name'> --  ; DOES>  n -- a ;
 \ Use:  8 half-array test - creates an array of 8 32 bit elements.
 \ Does>   4 test - returns the address of the 4th element of test.
  CREATE HERE SWAP halves DUP ALLOT ERASE
  DOES> SWAP halves + ;

\ *****     Words to implement an isaac rng    *****
8 half-array ]init-state

: init+!  \ ix-tgt ix-src -- ;
  ]init-state h@ SWAP ]init-state h+! ;

: init-right-xor!   \ ix-tgt ix-src shift-bits -- ;
  SWAP ]init-state h@ SWAP RSHIFT SWAP ]init-state TUCK h@ XOR SWAP h! ;

: init-left-xor!   \ ix-tgt ix-src shift-bits -- ;
  SWAP ]init-state h@ SWAP LSHIFT SWAP ]init-state TUCK h@ XOR SWAP h! ;

: mix
  0 1 11 init-left-xor!    3 0 init+!   1 2 init+!
  1 2  2 init-right-xor!   4 1 init+!   2 3 init+!
  2 3  8 init-left-xor!    5 2 init+!   3 4 init+!
  3 4 16 init-right-xor!   6 3 init+!   4 5 init+!
  4 5 10 init-left-xor!    7 4 init+!   5 6 init+!
  5 6  4 init-right-xor!   0 5 init+!   6 7 init+!
  6 7  8 init-left-xor!    1 6 init+!   7 0 init+!
  7 0  9 init-right-xor!   2 7 init+!   0 1 init+! ;

\ State variables and arrays
  VARIABLE aa   VARIABLE bb   VARIABLE cc   VARIABLE rand-count
  256 half-array ]mm
  256 half-array ]result

\ Jump table of xts used in isaac-iteration
: shift-xor0  aa DUP h@ DUP 13 LSHIFT XOR SWAP h! ;   \ -- ;
: shift-xor1  aa DUP h@ DUP 6  RSHIFT XOR SWAP h! ;   \ -- ;
: shift-xor2  aa DUP h@ DUP 2  LSHIFT XOR SWAP h! ;   \ -- ;
: shift-xor3  aa DUP h@ DUP 16 RSHIFT XOR SWAP h! ;   \ -- ;

HERE
  ' shift-xor0 , ' shift-xor1 , ' shift-xor2 , ' shift-xor3 ,
CONSTANT shift-xor-xts

: ]execute-shift-xorn   \ ix -- ; Executes the xt in shift-xor-xts
  CELLS shift-xor-xts + @ EXECUTE ;

: isaac-iteration   \ -- ;
  1 cc h+!  cc h@ bb h+!
  256 0 DO                    \  Python code
    I ]mm h@                  \ x = mm[i] Store mm[i] on the stack

    I 3 AND ]execute-shift-xorn
    \ Executes shift-xor0 .. 3 from shift-xor-xts above.

    aa DUP h@  I 128 XOR ]mm h@ + SWAP h!  \ aa = (mm[i^128] + aa)

    DUP 2 RSHIFT 0xFF AND ]mm h@ aa h@ + bb h@ +  \ mm[(x>>2) & 0xFF] + aa + bb)
    DUP I ]mm h!  \ y = mm[i] = ; Store in ]mm leave y on the stack

    10 RSHIFT 0xFF AND ]mm h@ +  \ mm[(y>>10) & 0xFF] + x)
    DUP bb h! I ]result h!  \ result[i] = self.bb = ; store in bb and result[i]

  LOOP
  0 rand-count ! ;

256 half-array ]seed
: zero-fill   \ a ct -- ;
  halves ERASE ;

: seed-mt  0 ]seed 256 zero-fill ;

: string>seed  \ a ct -- ;
  seed-mt  256 MIN ]seed 0 ]seed ?DO   COUNT I h!   4 +LOOP DROP ;

: mm-mt   0 ]mm  256 zero-fill ;
: init-vars   0 aa !  0 bb !  0 cc !  256 rand-count ! ;
: res-mt  0 ]result 256 zero-fill ;

: base-init-state
  8 ]init-state 0 ]init-state DO   0x9e3779b9 i h!   4 +LOOP
  mix mix mix mix ;

: init>mm-ix   \ ix -- ;
  0 ]init-state SWAP ]mm 8 halves MOVE ;

: init>mm   \ -- ;
  256 0 DO   mix I init>mm-ix   8 +LOOP
  0 aa h!  0 bb h!  0 cc h! ;

: default-seed  \ -- ;
  base-init-state init>mm ;

: seed>init-state>mm
  256 0 DO
    8 0 DO   I J + ]seed h@ I ]init-state h+!   LOOP
    mix
    0 ]init-state  I ]mm  8 halves MOVE
  8 +LOOP  ;

: init-mm-mix
  256 0 DO
    8 0 DO   I J + ]mm h@  I ]init-state h+!   LOOP
    mix
    I init>mm-ix
  8 +LOOP ;

: string-seed   \ str ct -- ;
  string>seed  base-init-state  seed>init-state>mm
  init-mm-mix  init-vars  res-mt ;

: random-next  \  -- h ;   32 bit result
  rand-count @ 255 > IF   isaac-iteration  0 rand-count !   THEN
  rand-count @ DUP ]result h@ SWAP 1+ rand-count ! ;

: rand-char   \ -- ch ;
  random-next 95 MOD 32 + ;

\ Encode, Decode and display.

\ Working buffers
1024 CONSTANT buff-size
CREATE buff-in     buff-size ALLOT
CREATE xor-out     buff-size ALLOT
CREATE caesar-out  buff-size ALLOT

: buff-count   \ adr -- addr+cell count ; \ Prepares buff for TYPE
  DUP CELL + SWAP @ ;

: buff.   buff-count TYPE ;   \ addr -- ;

: byte>hexstr   \ b -- str ct ;  \ Generates a 2 character hex string.
  BASE @ SWAP HEX 0 <# # # #> ROT BASE ! ;

: buff-hex.   \ addr --- ;
  buff-count BOUNDS ?DO   I C@ byte>hexstr TYPE   LOOP ;

: buff-empty   0 SWAP ! ;  \ addr -- ;  \ Empty the buffer. Sets length to zero.

: char-append   \ ch adr -- ;   \ Append ch to the buffer
  tuck  buff-count + C! 1 SWAP +! ;

: buff-copy   \ src dest -- ;   \ Copy buffer to buffer
  OVER @ CELL + MOVE ;

: buff-fill   \ str ct buff -- ;   \ Fill buffer with the contents of str ct
  2DUP ! CELL + SWAP MOVE ;

\ *****     XOR encode/decode     *****
: xor-byte   \ b -- b' ;
  rand-char XOR ;

: xor-code   \ str ct -- ;
  xor-out buff-empty
  BOUNDS ?DO   I C@  xor-byte xor-out char-append   LOOP ;

: init-rng"  [CHAR] " WORD COUNT string-seed ;

: xor-code-with"  \ str ct <key"> -- ;  str ct points to the text to encode
  \ Use:  s" Message" encode-xor-key" This is the key."
  \ Prints the encoded bytes in hex to the terminal.
  init-rng" xor-code ;

\ *****     Caesar encode/decode     *****
DEFER op    \ ' + for encode,  ' - for decode in caesar-code-ch

: encode ['] + IS op ;   \ Add the offset while encoding.
: decode ['] - IS op ;   \ Substract it to decode

: caesar-code-ch   \ c -- c' ;
  rand-char op 32 -  95 MOD
  BEGIN   DUP 0<   WHILE   95 +   REPEAT   32 + ;

: caesar   \ str ct -- ;
  \ The direction of caesar-code is modified by the encode / decode words
  \ eg. encode s" Message" caesar
  \     decode s" DntP8hg" caesar
  caesar-out buff-empty
  BOUNDS ?DO   I C@ caesar-code-ch caesar-out char-append   LOOP ;

: caesar-with"    \ str ct <key" -- ;
  \ The direction of caesar-code is modified by the encode / decode words
  \ eg. encode s" Message" caesar-with" Key"
  \     decode s" DntP8hg" caesar-with" Key"
  init-rng" caesar ;

\ *****     Demonstrate the encode/decode working     *****
: message  s" a Top Secret secret" ;

: out>in  \ buff-out -- buff-in' count ;
  buff-in buff-copy buff-in buff-count ;

: xor>in  xor-out out>in ;         \ -- buff-in' ct ;
: caesar>in   caesar-out out>in ;  \ -- buff-in' ct ;

: examples
  CR ." Raw message          : " message TYPE
  CR ." First encode."
  s" this is my secret key" string-seed  \ Set key
  message xor-code
  CR ." XOR encoded as hex   : " xor-out buff-hex.
  message encode caesar
  CR ." Caesar encoded as hex: " caesar-out buff-hex.
  CR ." Now decode "
  s" this is my secret key" string-seed  \ Set key
  xor>in xor-code
  CR ." XOR decoded          : " xor-out buff.
  caesar>in decode caesar
  CR ." Caesar decoded       : " caesar-out buff. ;
