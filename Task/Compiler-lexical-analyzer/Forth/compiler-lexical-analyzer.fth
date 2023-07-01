CREATE BUF 0 ,              \ single-character look-ahead buffer
CREATE COLUMN# 0 ,
CREATE LINE# 1 ,

: NEWLINE? ( c -- t|f)  DUP 10 = SWAP  13 =  OR ;
: +IN ( c --)
   1 SWAP  NEWLINE?
   IF 0 COLUMN# ! LINE# ELSE COLUMN# THEN
   +!  0 BUF ! ;
: PEEK   BUF @ 0= IF STDIN KEY-FILE BUF ! THEN BUF @ ;
: GETC   PEEK  DUP +IN ;
: SKIP   GETC DROP ;
: .LOCATION   7 .R  4 .R SPACE ;
: WHERE   COLUMN# @ LINE# @ ;
: .WHERE    WHERE .LOCATION ;
: .WHERE+   WHERE  SWAP 1+ SWAP .LOCATION ;

: EXPECT   GETC  OVER OVER =
   IF 2DROP
   ELSE CR ." stdin:" COLUMN# @ 0 LINE# @ 0
      <# #s #> TYPE ." :" <# #s #> TYPE ." : "
      ." unexpected `" EMIT ." ', expecting `" EMIT ." '" CR
      BYE
   THEN ;
: EQ   PEEK [CHAR] = = IF SKIP 2SWAP THEN
       ." Op_" TYPE CR  2DROP ;

CREATE ESC  4 C, CHAR $ C, CHAR $ C, CHAR \ C, 0 C,
: ?ESC?   CR ." Unknown escape sequence `\" EMIT ." '" CR BYE ;
: >ESC   ESC 4 + C!  ESC ;
: $$\n   10 ;
: $$\\   [CHAR] \ ;
: ESCAPE   DUP >ESC FIND IF NIP EXECUTE ELSE DROP ?ESC? THEN ;
: ?ESCAPE   DUP [CHAR] \ = IF DROP GETC ESCAPE THEN ;
: ?EOF   DUP 4 = IF CR ." End-of-file in string" CR BYE THEN ;
: ?EOL   DUP NEWLINE?
         IF CR ." End-of-line in string" CR BYE THEN ;
: STRING   PAD
   BEGIN  GETC ?EOF ?EOL DUP  [CHAR] " <>
   WHILE  OVER C! CHAR+
   REPEAT DROP  PAD TUCK - ;
: "TYPE"   [CHAR] " EMIT  TYPE  [CHAR] " EMIT ;

CREATE TOKEN  4 C, CHAR $ C, CHAR $ C, 0 C, 0 C,
: >HEX   DUP 9 > IF 7 + THEN [CHAR] 0 + ;
: HI!   $F0 AND  2/ 2/ 2/ 2/ >HEX  TOKEN 3 + C! ;
: LO!   $0F AND  >HEX TOKEN 4 + C! ;
: >TOKEN   DUP HI! LO!  TOKEN ;

: ?EOF   DUP 4 = IF CR ." End-of-file in comment" CR BYE THEN ;
: $$2F   PEEK [CHAR] * =
   IF SKIP
       BEGIN
   	GETC ?EOF  [CHAR] * =
   	PEEK [CHAR] / =  AND
       UNTIL  SKIP
   ELSE  .WHERE ." Op_divide" CR THEN ;
: $$22   .WHERE ." String " STRING "TYPE" CR ;
: $$27   .WHERE GETC ?ESCAPE ." Integer " . [CHAR] ' EXPECT CR ;
: $$04   .WHERE ." End_of_input" CR BYE ;
: $$2D   .WHERE ." Op_subtract" CR ;
: $$2B   .WHERE ." Op_add" CR ;
: $$25   .WHERE ." Op_mod" CR ;
: $$2A   .WHERE ." Op_multiply" CR ;
: $$7B   .WHERE ." LeftBrace" CR ;
: $$7D   .WHERE ." RightBrace" CR ;
: $$2C   .WHERE ." Comma" CR ;
: $$29   .WHERE ." RightParen" CR ;
: $$28   .WHERE ." LeftParen" CR ;
: $$3B   .WHERE ." Semicolon" CR ;
: $$3D   .WHERE s" equal" s" assign" EQ ;
: $$21   .WHERE s" notequal" s" not" EQ ;
: $$3C   .WHERE s" lessequal" s" less" EQ ;
: $$3E   .WHERE s" greaterequal" s" greater" EQ ;
: $$26   .WHERE [CHAR] & EXPECT  ." Op_and" CR ;
: $$7C   .WHERE [CHAR] | EXPECT  ." Op_or" CR ;
: $$20   ;   \ space

CREATE KEYWORD  0 C, CHAR $ C, CHAR $ C, 5 CHARS ALLOT
: >KEYWORD   DUP  2 + KEYWORD C!
             KEYWORD 3 + SWAP CMOVE  KEYWORD ;
: FIND-KW   DUP 5 <=
   IF 2DUP >KEYWORD FIND
      IF TRUE 2SWAP 2DROP ELSE DROP FALSE THEN
   ELSE FALSE THEN ;

: $$if   ." Keyword_if" ;
: $$else   ." Keyword_else" ;
: $$while   ." Keyword_while" ;
: $$print   ." Keyword_print" ;
: $$putc   ." Keyword_putc" ;

: DIGIT?   48 58 WITHIN ;
: ALPHA?   DUP  95 = SWAP		  \ underscore?
           DUP 97 123 WITHIN SWAP	  \ lower?
           65 91 WITHIN  OR OR ;	  \ upper?
: ALNUM?   DUP DIGIT? SWAP  ALPHA? OR ;
: INTEGER   0
   BEGIN  PEEK DIGIT?
   WHILE  GETC [CHAR] 0 -  SWAP 10 * +
   REPEAT ;
: ?INTEGER?   CR ." Invalid number" CR BYE ;
: ?INTEGER   PEEK ALPHA? IF ?INTEGER? THEN ;
: DIGIT   .WHERE+ ." Integer " INTEGER ?INTEGER . CR ;
: NAME   PAD
         BEGIN  PEEK ALNUM?
	 WHILE GETC OVER C! CHAR+
	 REPEAT  PAD TUCK - ;
: IDENT   ." Identifier " TYPE ;
: ALPHA   .WHERE+ NAME FIND-KW
          IF EXECUTE ELSE IDENT THEN CR ;
: ?CHAR?   CR ." Character '" EMIT ." ' not recognized" CR BYE ;
: SPACE?   DUP BL = SWAP  9 14 WITHIN  OR ;
: SKIP-SPACE   BEGIN PEEK SPACE? WHILE SKIP REPEAT ;
: CONSUME
   SKIP-SPACE
   PEEK DIGIT? IF DIGIT ELSE
    PEEK ALPHA? IF ALPHA ELSE
     PEEK >TOKEN FIND
     IF SKIP EXECUTE ELSE GETC ?CHAR? BYE THEN
   THEN THEN ;
: TOKENIZE   BEGIN CONSUME AGAIN ;
TOKENIZE
