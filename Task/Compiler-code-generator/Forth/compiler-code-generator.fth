CREATE BUF 0 ,
: PEEK   BUF @ 0= IF KEY BUF ! THEN BUF @ ;
: GETC   PEEK  0 BUF ! ;
: SPACE?   DUP BL = SWAP 9 14 WITHIN OR ;
: >SPACE   BEGIN PEEK SPACE? WHILE GETC DROP REPEAT ;
: DIGIT?   48 58 WITHIN ;
: >Integer   >SPACE  0
   BEGIN  PEEK DIGIT?
   WHILE  GETC [CHAR] 0 -  SWAP 10 * +  REPEAT ;
: SKIP ( xt --)
   BEGIN PEEK OVER EXECUTE WHILE GETC DROP REPEAT DROP ;
: WORD ( xt -- c-addr)  DUP >R SKIP  PAD 1+
   BEGIN PEEK R@ EXECUTE INVERT
   WHILE GETC OVER C! CHAR+
   REPEAT  R> SKIP  PAD TUCK - 1-  PAD C! ;
: INTERN ( c-addr -- c-addr)
   HERE TUCK OVER C@ CHAR+ DUP ALLOT CMOVE ;
: "?   [CHAR] " = ;
: "TYPE"   [CHAR] " EMIT  TYPE  [CHAR] " EMIT ;
: .   0 .R ;
: 3@ ( addr -- w3 w2 w1)
   [ 2 CELLS ]L + DUP @ SWAP CELL - DUP @ SWAP CELL - @ ;

CREATE BUF' 12 ALLOT
: PREPEND ( c-addr c -- c-addr)  BUF' 1+ C!
   COUNT 10 MIN DUP 1+ BUF' C!  BUF' 2 + SWAP CMOVE  BUF' ;
: >NODE ( c-addr -- n)   [CHAR] $ PREPEND  FIND
   IF EXECUTE ELSE ." unrecognized node " COUNT TYPE CR THEN ;
: NODE ( n left right -- addr)  HERE >R , , , R> ;

: CONS ( a b l -- l)  HERE >R , , , R> ;
: FIRST ( l -- a)  [ 2 CELLS ]L + @ ;
: SECOND ( l -- b)  CELL+ @ ;
: C=? ( c-addr1 c-addr2 -- t|f)  COUNT ROT COUNT COMPARE 0= ;
: LOOKUP ( c-addr l -- n t | c-addr f)
   BEGIN DUP WHILE OVER OVER FIRST C=?
     IF NIP SECOND TRUE EXIT THEN  @
   REPEAT  DROP FALSE ;

CREATE GLOBALS 0 ,  CREATE STRINGS 0 ,
: DEPTH ( pool -- n)  DUP IF SECOND 1+ THEN ;
: FISH ( c-addr pool -- n pool') TUCK LOOKUP  IF SWAP
   ELSE INTERN OVER DEPTH ROT OVER >R CONS  R> SWAP THEN ;
: >Identifier   ['] SPACE? WORD GLOBALS @ FISH GLOBALS ! ;
: >String       ['] "? WORD STRINGS @ FISH STRINGS ! ;
: >;   0 ;
: HANDLER   [CHAR] @ PREPEND  FIND DROP ;
: READER ( c-addr -- xt t | f)
   [CHAR] > PREPEND  FIND  DUP 0= IF NIP THEN ;
DEFER GETAST
: READ ( c-addr -- right left)  READER
   IF EXECUTE 0 ELSE GETAST GETAST THEN SWAP ;
: (GETAST)   ['] SPACE? WORD  DUP HANDLER >R  READ  R> NODE ;
' (GETAST) IS GETAST

CREATE PC 0 ,
: i32! ( n addr --)
   OVER           $FF AND OVER C! 1+
   OVER  8 RSHIFT $FF AND OVER C! 1+
   OVER 16 RSHIFT $FF AND OVER C! 1+
   OVER 24 RSHIFT $FF AND OVER C!    DROP DROP ;
: i32, ( n --)  HERE i32!  4 ALLOT  4 PC +! ;
: i8, ( c --)  C,  1 PC +! ;
: i8@+   DUP 1+ SWAP C@  1 PC +! ;
: i32@+ ( addr -- addr+4 n)
   i8@+                 >R  i8@+  8 LSHIFT R> OR >R
   i8@+ 16 LSHIFT R> OR >R  i8@+ 24 LSHIFT R> OR ;

CREATE #OPS 0 ,
: OP:   CREATE #OPS @ ,  1 #OPS +!  DOES> @ ;
OP: fetch  OP: store  OP: push  OP: jmp  OP: jz
OP: prtc   OP: prti   OP: prts  OP: neg  OP: not
OP: add    OP: sub    OP: mul   OP: div  OP: mod
OP: lt     OP: gt     OP: le    OP: ge
OP: eq     OP: ne     OP: and   OP: or   OP: halt

: GEN ( ast --)  3@ EXECUTE ;
: @; ( r l)  DROP DROP ;
: @Identifier   fetch i8, i32, DROP ;
: @Integer    push i8, i32, DROP ;
: @String    push i8, i32, DROP ;
: @Prtc   GEN prtc i8, DROP ;
: @Prti   GEN prti i8, DROP ;
: @Prts   GEN prts i8, DROP ;
: @Not    GEN not i8, DROP ;
: @Negate   GEN neg i8, DROP ;
: @Sequence   GEN GEN ;
: @Assign   CELL+ @ >R GEN  store i8, R> i32, ;
: @While   PC @ SWAP  GEN  jz i8, HERE >R 0 i32,
   SWAP GEN  jmp i8, i32,  PC @ R> i32! ;
: @If   GEN  jz i8, HERE >R 0 i32,
   CELL+ DUP CELL+ @ DUP @ ['] @; = IF DROP @
   ELSE SWAP @ GEN  jmp i8, HERE 0 i32,  PC @ R> i32!  >R
   THEN  GEN PC @ R> i32! ;
: BINARY   >R GEN GEN R> i8, ;
: @Subtract   sub BINARY ;  : @Add            add BINARY ;
: @Mod        mod BINARY ;  : @Multiply       mul BINARY ;
: @Divide     div BINARY ;
: @Less       lt  BINARY ;  : @LessEqual      le  BINARY ;
: @Greater    gt  BINARY ;  : @GreaterEqual   ge  BINARY ;
: @Equal      eq  BINARY ;  : @NotEqual       ne  BINARY ;
: @And        and BINARY ;  : @Or             or  BINARY ;

: REVERSE ( l -- l')  0 SWAP
   BEGIN DUP WHILE TUCK DUP @  ROT ROT  ! REPEAT  DROP ;
: .STRINGS   STRINGS @ REVERSE  BEGIN DUP
   WHILE DUP FIRST COUNT "TYPE" CR @ REPEAT DROP ;
: .HEADER ( --)
   ." Datasize: " GLOBALS @ DEPTH . SPACE
   ." Strings: "  STRINGS @ DEPTH . CR  .STRINGS ;
: GENERATE ( ast -- addr u)
   0 PC ! HERE >R  GEN halt i8,  R> PC @ ;
: ,"   [CHAR] " PARSE TUCK HERE SWAP CMOVE ALLOT ;
CREATE "OPS"
," fetch store push  jmp   jz    prtc  prti  prts  "
," neg   not   add   sub   mul   div   mod   lt    "
," gt    le    ge    eq    ne    and   or    halt  "
: .i32   i32@+ . ;
: .[i32]   [CHAR] [ EMIT .i32 [CHAR] ] EMIT ;
: .off   [CHAR] ( EMIT PC @ >R i32@+ DUP R> - . [CHAR] ) EMIT
    SPACE . ;
CREATE .INT ' .[i32] , ' .[i32] , ' .i32 , ' .off , ' .off ,
: EMIT ( addr u --)  >R 0 PC !
   BEGIN PC @ R@ <
   WHILE PC @ 5 .R SPACE  i8@+
     DUP 6 * "OPS" + 6 TYPE
     DUP 5 < IF CELLS .INT + @ EXECUTE ELSE DROP THEN CR
   REPEAT DROP R> DROP ;
GENERATE EMIT BYE
