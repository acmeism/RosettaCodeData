CREATE BUF 0 ,              \ single-character look-ahead buffer
: PEEK   BUF @ 0= IF KEY BUF ! THEN BUF @ ;
: GETC   PEEK  0 BUF ! ;
: SPACE?   DUP BL = SWAP  9 14 WITHIN  OR ;
: >SPACE   BEGIN PEEK SPACE? WHILE GETC DROP REPEAT ;
: DIGIT?   48 58 WITHIN ;
: GETINT   >SPACE  0
   BEGIN  PEEK DIGIT?
   WHILE  GETC [CHAR] 0 -  SWAP 10 * +
   REPEAT ;
: GETNAM   >SPACE PAD 1+
   BEGIN PEEK SPACE? INVERT
   WHILE GETC OVER C! CHAR+
   REPEAT  PAD TUCK - 1-  PAD C! ;
: GETSTR   >SPACE PAD  1+ GETC DROP   \ skip leading "
   BEGIN GETC  DUP [CHAR] " <>
   WHILE OVER C! CHAR+
   REPEAT  DROP  PAD TUCK - 1-  PAD C! ;
: INTERN   HERE SWAP  DUP C@ 1+ BOUNDS DO I C@ C, LOOP  ALIGN ;

CREATE #TK 0 ,
: TK:   CREATE #TK @ ,  1 #TK +!  DOES> @ ;
TK: End_of_input      TK: Keyword_if        TK: Keyword_else
TK: Keyword_while     TK: Keyword_print     TK: Keyword_putc
TK: String            TK: Integer           TK: Identifier
TK: LeftParen         TK: RightParen
TK: LeftBrace         TK: RightBrace
TK: Semicolon         TK: Comma
TK: Op_assign         TK: Op_not
: (BINARY?)   [ #TK @ ] literal >= ;
TK: Op_subtract       TK: Op_add
TK: Op_mod            TK: Op_multiply       TK: Op_divide
TK: Op_equal          TK: Op_notequal
TK: Op_less           TK: Op_lessequal
TK: Op_greater        TK: Op_greaterequal
TK: Op_and            TK: Op_or
CREATE TOKEN  0 , 0 , 0 , 0 ,
: TOKEN-TYPE   TOKEN 2 CELLS + @ ;
: TOKEN-VALUE   TOKEN 3 CELLS + @ ;
: GETTOK   GETINT GETINT TOKEN 2!
           GETNAM FIND DROP EXECUTE
	   DUP Integer    = IF GETINT ELSE
	   DUP String     = IF GETSTR INTERN ELSE
	   DUP Identifier = IF GETNAM INTERN ELSE
	   0 THEN THEN THEN
	   TOKEN 3 CELLS + !  TOKEN 2 CELLS + ! ;
: BINARY?   TOKEN-TYPE (BINARY?) ;

CREATE PREC #TK @ CELLS ALLOT  PREC #TK @ CELLS -1 FILL
: PREC!   CELLS PREC + ! ;
14 Op_not          PREC!  13 Op_multiply     PREC!
13 Op_divide       PREC!  13 Op_mod          PREC!
12 Op_add          PREC!  12 Op_subtract     PREC!
10 Op_less         PREC!  10 Op_greater      PREC!
10 Op_lessequal    PREC!  10 Op_greaterequal PREC!
 9 Op_equal        PREC!   9 Op_notequal     PREC!
 5 Op_and          PREC!   4 Op_or           PREC!
: PREC@   CELLS PREC + @ ;

\ Each AST Node is a sequence of cells in data space consisting
\ of the execution token of a printing word, followed by that
\ node's data.  Each printing word receives the address of the
\ node's data, and is responsible for printing that data
\ appropriately.

DEFER .NODE
: .NULL   DROP ." ;" CR ;
CREATE $NULL  ' .NULL ,
: .IDENTIFIER   ." Identifier " @ COUNT TYPE CR ;
: $IDENTIFIER ( a-addr --)  HERE SWAP  ['] .IDENTIFIER , , ;
: .INTEGER   ." Integer " @ . CR ;
: $INTEGER ( n --)  HERE SWAP  ['] .INTEGER , , ;
: "TYPE"   [CHAR] " EMIT  TYPE  [CHAR] " EMIT ;
: .STRING   ." String " @ COUNT "TYPE" CR ;
: $STRING ( a-addr --)  HERE SWAP  ['] .STRING , , ;
: .LEAF   DUP  @ COUNT TYPE CR  CELL+ @ .NODE  0 .NULL ;
: LEAF   CREATE HERE CELL+ ,  BL WORD INTERN .
          DOES> HERE >R ['] .LEAF ,  @ , ,  R> ;
LEAF $PRTC Prtc    LEAF $PRTS Prts       LEAF $PRTI Prti
LEAF $NOT Not      LEAF $NEGATE Negate
: .BINARY   DUP  @ COUNT TYPE CR
            CELL+ DUP @ .NODE  CELL+ @ .NODE ;
: BINARY   CREATE HERE CELL+ ,  BL WORD INTERN .
           DOES> HERE >R ['] .BINARY ,  @ ,  SWAP 2,  R> ;
BINARY $SEQUENCE Sequence   BINARY $ASSIGN Assign
BINARY $WHILE While         BINARY $IF If
BINARY $SUBTRACT Subtract   BINARY $ADD Add
BINARY $MOD Mod             BINARY $MULTIPLY Multiply
BINARY $DIVIDE Divide
BINARY $LESS Less           BINARY $LESSEQUAL LessEqual
BINARY $GREATER Greater     BINARY $GREATEREQUAL GreaterEqual
BINARY $EQUAL Equal         BINARY $NOTEQUAL NotEqual
BINARY $AND And             BINARY $OR Or

: TOK-CONS ( x* -- node-xt) TOKEN-TYPE  CASE
   Op_subtract     OF ['] $SUBTRACT     ENDOF
   Op_add          OF ['] $ADD          ENDOF
   op_mod          OF ['] $MOD          ENDOF
   op_multiply     OF ['] $MULTIPLY     ENDOF
   Op_divide       OF ['] $DIVIDE       ENDOF
   Op_equal        OF ['] $EQUAL        ENDOF
   Op_notequal     OF ['] $NOTEQUAL     ENDOF
   Op_less         OF ['] $LESS         ENDOF
   Op_lessequal    OF ['] $LESSEQUAL    ENDOF
   Op_greater      OF ['] $GREATER      ENDOF
   Op_greaterequal OF ['] $GREATEREQUAL ENDOF
   Op_and          OF ['] $AND          ENDOF
   Op_or           OF ['] $OR           ENDOF
   ENDCASE ;

: (.NODE)   DUP CELL+ SWAP @ EXECUTE ;
' (.NODE) IS .NODE

: .- ( n --)  0 <# #S #> TYPE ;
: EXPECT ( tk --)  DUP TOKEN-TYPE <>
   IF CR ." stdin:" TOKEN 2@ SWAP .- ." :" .-
     ." : unexpected token, expecting " . CR BYE
   THEN  DROP GETTOK ;
: '('   LeftParen EXPECT ;
: ')'   RightParen EXPECT ;
: '}'   RightBrace EXPECT ;
: ';'   Semicolon EXPECT ;
: ','   Comma EXPECT ;
: '='   Op_assign EXPECT ;

DEFER *EXPR  DEFER EXPR  DEFER STMT
: PAREN-EXPR   '(' EXPR ')' ;
: PRIMARY
   TOKEN-TYPE LeftParen   = IF PAREN-EXPR              EXIT THEN
   TOKEN-TYPE Op_add      = IF GETTOK 12 *EXPR         EXIT THEN
   TOKEN-TYPE Op_subtract = IF GETTOK 14 *EXPR $NEGATE EXIT THEN
   TOKEN-TYPE Op_not      = IF GETTOK 14 *EXPR $NOT    EXIT THEN
   TOKEN-TYPE Identifier  = IF TOKEN-VALUE $IDENTIFIER      ELSE
   TOKEN-TYPE Integer     = IF TOKEN-VALUE $INTEGER    THEN THEN
   GETTOK ;
: (*EXPR) ( n -- node)
   PRIMARY ( n node)
   BEGIN OVER TOKEN-TYPE PREC@ SWAP OVER <=  BINARY?  AND
   WHILE ( n node prec) 1+ TOK-CONS SWAP GETTOK *EXPR SWAP EXECUTE
   REPEAT ( n node prec) DROP NIP ( node) ;
: (EXPR)   0 *EXPR ;
: -)?   TOKEN-TYPE RightParen <> ;
: -}?   TOKEN-TYPE RightBrace <> ;
: (STMT)
   TOKEN-TYPE Semicolon = IF GETTOK STMT EXIT THEN
   TOKEN-TYPE Keyword_while =
     IF GETTOK  PAREN-EXPR STMT $WHILE  EXIT THEN
   TOKEN-TYPE Keyword_if =
     IF GETTOK  PAREN-EXPR STMT
       TOKEN-TYPE Keyword_else = IF GETTOK STMT ELSE $NULL THEN
       $IF $IF EXIT
     THEN
   TOKEN-TYPE Keyword_putc =
     IF GETTOK  PAREN-EXPR ';' $PRTC  EXIT THEN
   TOKEN-TYPE Keyword_print =
     IF GETTOK  '(' $NULL
        BEGIN TOKEN-TYPE String =
           IF TOKEN-VALUE $STRING $PRTS  GETTOK
           ELSE EXPR $PRTI THEN  $SEQUENCE  -)?
        WHILE ',' REPEAT  ')' ';'  EXIT THEN
   TOKEN-TYPE Identifier =
     IF TOKEN-VALUE $IDENTIFIER GETTOK '=' EXPR ';' $ASSIGN
        EXIT THEN
   TOKEN-TYPE LeftBrace =
     IF $NULL GETTOK BEGIN -}? WHILE STMT $SEQUENCE REPEAT
        '}' EXIT THEN
   TOKEN-TYPE End_of_input = IF EXIT THEN  EXPR ;
' (*EXPR) IS *EXPR  ' (EXPR) IS EXPR  ' (STMT) IS STMT

: -EOI?   TOKEN-TYPE End_of_input <> ;
: PARSE   $NULL GETTOK BEGIN -EOI? WHILE STMT $SEQUENCE REPEAT ;
PARSE  .NODE
