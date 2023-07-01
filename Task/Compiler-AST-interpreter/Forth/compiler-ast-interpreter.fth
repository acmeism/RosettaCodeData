CREATE BUF 0 ,              \ single-character look-ahead buffer
: PEEK   BUF @ 0= IF KEY BUF ! THEN BUF @ ;
: GETC   PEEK  0 BUF ! ;
: SPACE?   DUP BL = SWAP  9 14 WITHIN  OR ;
: >SPACE   BEGIN PEEK SPACE? WHILE GETC DROP REPEAT ;
: DIGIT?   48 58 WITHIN ;
: GETINT   >SPACE  0
   BEGIN  PEEK DIGIT?
   WHILE  GETC [CHAR] 0 -  SWAP 10 * +  REPEAT ;
: GETNAM   >SPACE PAD 1+
   BEGIN PEEK SPACE? INVERT
   WHILE GETC OVER C! CHAR+
   REPEAT  PAD TUCK - 1-  PAD C! ;
: GETSTR ( -- c-addr u)
   HERE >R 0  >SPACE GETC DROP  \ skip leading "
   BEGIN GETC DUP [CHAR] " <> WHILE C, 1+ REPEAT
   DROP R> SWAP ;
: \TYPE   BEGIN DUP 0> WHILE
   OVER C@ [CHAR] \ = IF
     1- >R CHAR+ R>
     OVER C@ [CHAR] n = IF CR ELSE
     OVER C@ [CHAR] \ = IF [CHAR] \ EMIT THEN THEN
   ELSE OVER C@ EMIT THEN  1- >R CHAR+ R> REPEAT
   DROP DROP ;
: .   S>D SWAP OVER DABS <# #S ROT SIGN #> TYPE ;

: CONS ( v l -- l)  HERE >R SWAP , , R> ;
: HEAD ( l -- v)  @ ;
: TAIL ( l -- l)  CELL+ @ ;
CREATE GLOBALS 0 ,
: DECLARE ( c-addr -- a-addr)  HERE TUCK
   OVER C@ CHAR+  DUP ALLOT CMOVE  HERE SWAP 0 ,
   GLOBALS @ CONS  GLOBALS ! ;
: LOOKUP ( c-addr -- a-addr)  DUP COUNT  GLOBALS @ >R
   BEGIN R@ 0<>
   WHILE R@ HEAD COUNT  2OVER COMPARE 0=
     IF 2DROP DROP  R> HEAD DUP C@ CHAR+ + EXIT
     THEN  R> TAIL >R
   REPEAT
   2DROP RDROP  DECLARE ;

DEFER GETAST
: >Identifier   GETNAM LOOKUP  0 ;
: >Integer   GETINT  0 ;
: >String   GETSTR ;
: >;   0 0 ;
: NODE ( xt left right -- addr)  HERE >R , , , R> ;
CREATE BUF' 12 ALLOT
: PREPEND ( c-addr c -- c-addr)  BUF' 1+ C!
   COUNT DUP 1+ BUF' C!  BUF' 2 + SWAP CMOVE  BUF' ;
: HANDLER ( c-addr -- xt)  [CHAR] $ PREPEND  FIND
   0= IF ." No handler for AST node '" COUNT TYPE ." '" THEN ;
: READER ( c-addr -- xt t | f)
   [CHAR] > PREPEND  FIND  DUP 0= IF NIP THEN ;
: READ ( c-addr -- left right)  READER
   IF EXECUTE ELSE GETAST GETAST THEN ;
: (GETAST)   GETNAM  DUP HANDLER SWAP  READ  NODE ;
' (GETAST) IS GETAST

: INTERP   DUP 2@  ROT [ 2 CELLS ]L + @ EXECUTE ;
: $;   DROP DROP ;
: $Identifier ( l r -- a-addr)  DROP @ ;
: $Integer ( l r -- n)  DROP ;
: $String ( l r -- c-addr u)  ( noop) ;
: $Prtc ( l r --)  DROP INTERP EMIT ;
: $Prti ( l r --)  DROP INTERP . ;
: $Prts ( l r --)  DROP INTERP \TYPE ;
: $Not ( l r --)  DROP INTERP 0= ;
: $Negate ( l r --) DROP INTERP NEGATE ;
: $Sequence ( l r --) SWAP INTERP INTERP ;
: $Assign ( l r --)  SWAP CELL+ @ >R  INTERP  R> ! ;
: $While ( l r --)
   >R BEGIN DUP INTERP WHILE R@ INTERP REPEAT  RDROP DROP ;
: $If ( l r --)  SWAP INTERP 0<> IF CELL+ THEN @ INTERP ;
: $Subtract ( l r -- n) >R INTERP R> INTERP - ;
: $Add   >R INTERP R> INTERP + ;
: $Mod   >R INTERP R> INTERP MOD ;
: $Multiply   >R INTERP R> INTERP * ;
: $Divide   >R INTERP S>D R> INTERP SM/REM SWAP DROP ;
: $Less   >R INTERP R> INTERP < ;
: $LessEqual   >R INTERP R> INTERP <= ;
: $Greater   >R INTERP R> INTERP > ;
: $GreaterEqual   >R INTERP R> INTERP >= ;
: $Equal   >R INTERP R> INTERP = ;
: $NotEqual   >R INTERP R> INTERP <> ;
: $And   >R INTERP IF R> INTERP 0<> ELSE RDROP 0 THEN ;
: $Or   >R INTERP IF RDROP -1 ELSE R> INTERP 0<> THEN ;

GETAST INTERP
