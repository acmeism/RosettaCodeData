CREATE BUF 0 ,              \ single-character look-ahead buffer
: PEEK   BUF @ 0= IF KEY BUF ! THEN BUF @ ;
: GETC   PEEK  0 BUF ! ;
: SPACE?   DUP BL = SWAP 9 14 WITHIN OR ;
: >SPACE   BEGIN PEEK SPACE? WHILE GETC DROP REPEAT ;
: DIGIT?   48 58 WITHIN ;
: >INT ( -- n)   >SPACE  0
   BEGIN  PEEK DIGIT?
   WHILE  GETC [CHAR] 0 -  SWAP 10 * +  REPEAT ;
CREATE A 0 ,
: C@A ( -- c)  A @ C@ ;
: C@A+ ( -- c)  C@A  1 CHARS A +! ;
: C!A+ ( c --)  A @ C!  1 CHARS A +! ;
: WORD ( -- c-addr)  >SPACE  PAD 1+ A !
   BEGIN PEEK SPACE? INVERT WHILE GETC C!A+ REPEAT
   >SPACE  PAD A @ OVER - 1- PAD C! ;
: >STRING ( -- c-addr)  >SPACE GETC DROP  PAD 1+ A !
   BEGIN PEEK [CHAR] " <> WHILE GETC C!A+ REPEAT
   GETC DROP  PAD A @ OVER - 1- PAD C! ;
: \INTERN ( c-addr -- c-addr)  HERE >R  A ! C@A+ DUP C,
   BEGIN DUP WHILE C@A+
     DUP [CHAR] \ = IF DROP -1 R@ +!  C@A+
       [CHAR] n = IF 10 ELSE [CHAR] \ THEN
     THEN C,  1-
   REPEAT  DROP R> ;
: .   0 .R ;

CREATE DATA 0 ,
CREATE STRINGS 0 ,
: >DATA   HERE DATA !
   WORD DROP  >INT 4 * BEGIN DUP WHILE 0 C, 1- REPEAT DROP ;
: >STRINGS   HERE STRINGS !
   WORD DROP  >INT DUP >R CELLS  ALLOT
   0 BEGIN DUP R@ < WHILE
     DUP CELLS >STRING \INTERN STRINGS @ ROT + !  1+
   REPEAT R> DROP DROP ;
: >HEADER   >DATA >STRINGS ;
: i32! ( n addr --)
   OVER           $FF AND OVER C! 1+
   OVER  8 RSHIFT $FF AND OVER C! 1+
   OVER 16 RSHIFT $FF AND OVER C! 1+
   SWAP 24 RSHIFT $FF AND SWAP C! ;
: i32@ ( addr -- n) >R  \ This is kinda slow... hmm
   R@     C@
   R@ 1 + C@  8 LSHIFT OR
   R@ 2 + C@ 16 LSHIFT OR
   R> 3 + C@ 24 LSHIFT OR
   DUP $7FFFFFFF AND SWAP $80000000 AND - ;  \ sign extend
: i32, ( n --)  HERE  4 ALLOT  i32! ;
: i32@+ ( -- n)  A @ i32@  A @ 4 + A ! ;
CREATE BYTECODE 0 ,
: @fetch   i32@+ 4 * DATA @ + i32@ ;
: @store   i32@+ 4 * DATA @ + i32! ;
: @jmp     i32@+ BYTECODE @ + A ! ;
: @jz      IF 4 A +! ELSE @jmp THEN ;
: @prts    CELLS STRINGS @ + @ COUNT TYPE ;
: @div     >R S>D R> SM/REM SWAP DROP ;
CREATE OPS
' @fetch , ' @store , ' i32@+ , ' @jmp ,   ' @jz ,
' EMIT ,   ' . ,      ' @prts , ' NEGATE , ' 0= ,
' + ,      ' - ,      ' * ,     ' @div ,   ' MOD ,
' < ,      ' > ,      ' <= ,    ' >= ,
' = ,      ' <> ,     ' AND ,   ' OR ,     ' BYE ,
CREATE #OPS 0 ,
: OP:   CREATE #OPS @ ,  1 #OPS +!  DOES> @ ;
OP: fetch  OP: store  OP: push  OP: jmp  OP: jz
OP: prtc   OP: prti   OP: prts  OP: neg  OP: not
OP: add    OP: sub    OP: mul   OP: div  OP: mod
OP: lt     OP: gt     OP: le    OP: ge
OP: eq     OP: ne     OP: and   OP: or   OP: halt
: >OP   WORD FIND
   0= IF ." Unrecognized opcode" ABORT THEN EXECUTE ;
: >i32   >INT i32, ;
: >[i32]  GETC DROP >i32 GETC DROP ;
: >OFFSET   WORD DROP ( drop relative offset) >i32 ;
CREATE >PARAM  ' >[i32] DUP , , ' >i32 , ' >OFFSET DUP , ,
: >BYTECODE   HERE >R
   BEGIN >INT DROP  >OP >R  R@ C,
     R@ 5 < IF R@ CELLS >PARAM + @ EXECUTE THEN
   R> halt = UNTIL  R> BYTECODE ! ;
: RUN   BYTECODE @ A !
   BEGIN C@A+ CELLS OPS + @ EXECUTE AGAIN ;
>HEADER >BYTECODE RUN
