INT base=10;
MODE FIXED = LONG REAL; # numbers in the format 9,999.999 #

#IF build abstract syntax tree and then EVAL tree #
MODE AST = UNION(NODE, FIXED);
MODE NUM = REF AST;
MODE NODE = STRUCT(NUM a, PROC (FIXED,FIXED)FIXED op, NUM b);

OP EVAL = (NUM ast)FIXED:(
  CASE ast IN
    (FIXED num): num,
    (NODE fork): (op OF fork)(EVAL( a OF fork), EVAL (b OF fork))
  ESAC
);

OP + = (NUM a,b)NUM: ( HEAP AST := NODE(a, (FIXED a,b)FIXED:a+b, b) );
OP - = (NUM a,b)NUM: ( HEAP AST := NODE(a, (FIXED a,b)FIXED:a-b, b) );
OP * = (NUM a,b)NUM: ( HEAP AST := NODE(a, (FIXED a,b)FIXED:a*b, b) );
OP / = (NUM a,b)NUM: ( HEAP AST := NODE(a, (FIXED a,b)FIXED:a/b, b) );
OP **= (NUM a,b)NUM: ( HEAP AST := NODE(a, (FIXED a,b)FIXED:a**b, b) );

#ELSE simply use REAL arithmetic with no abstract syntax tree at all # CO
MODE NUM = FIXED, AST = FIXED;
OP EVAL = (FIXED num)FIXED: num;
#FI# END CO

MODE LEX = PROC (TOK)NUM;
MODE MONADIC =PROC (NUM)NUM;
MODE DIADIC = PROC (NUM,NUM)NUM;

MODE TOK = CHAR;
MODE ACTION = UNION(STACKACTION, LEX, MONADIC, DIADIC);
MODE OPVAL = STRUCT(INT prio, ACTION action);
MODE OPITEM = STRUCT(TOK token, OPVAL opval);

[256]STACKITEM stack;
MODE STACKITEM = STRUCT(NUM value, OPVAL op);
MODE STACKACTION = PROC (REF STACKITEM)VOID;

PROC begin = (REF STACKITEM top)VOID: prio OF op OF top -:= +10;
PROC end = (REF STACKITEM top)VOID: prio OF op OF top -:= -10;

OP ** = (COMPL a,b)COMPL: complex exp(complex ln(a)*b);

[8]OPITEM op list :=(
#  OP  PRIO ACTION #
  ("^", (8, (NUM a,b)NUM: a**b)),
  ("*", (7, (NUM a,b)NUM: a*b)),
  ("/", (7, (NUM a,b)NUM: a/b)),
  ("+", (6, (NUM a,b)NUM: a+b)),
  ("-", (6, (NUM a,b)NUM: a-b)),
  ("(",(+10, begin)),
  (")",(-10, end)),
  ("?", (9, LEX:SKIP))
);

PROC op dict = (TOK op)REF OPVAL:(
# This can be unrolled to increase performance #
  REF OPITEM candidate;
  FOR i TO UPB op list WHILE
    candidate := op list[i];
# WHILE # op /= token OF candidate DO
    SKIP
  OD;
  opval OF candidate
);

PROC build ast = (STRING expr)NUM:(

  INT top:=0;

  PROC compress ast stack = (INT prio, NUM in value)NUM:(
    NUM out value := in value;
    FOR loc FROM top BY -1 TO 1 WHILE
      REF STACKITEM stack top := stack[loc];
  # WHILE # ( top >= LWB stack | prio <= prio OF op OF stack top | FALSE ) DO
      top := loc - 1;
      out value :=
        CASE action OF op OF stack top IN
          (MONADIC op): op(value OF stack top), # not implemented #
          (DIADIC op): op(value OF stack top,out value)
        ESAC
    OD;
    out value
  );

  NUM value := NIL;
  FIXED num value;
  INT decimal places;

  FOR i TO UPB expr DO
    TOK token = expr[i];
    REF OPVAL this op := op dict(token);
    CASE action OF this op IN
      (STACKACTION action):(
        IF prio OF thisop = -10 THEN
          value := compress ast stack(0, value)
        FI;
        IF top >= LWB stack THEN
          action(stack[top])
        FI
      ),
      (LEX):( # a crude lexer #
        SHORT INT digit = ABS token - ABS "0";
        IF 0<= digit AND digit < base THEN
          IF NUM(value) IS NIL THEN # first digit #
            decimal places := 0;
            value := HEAP AST := num value := digit
          ELSE
            NUM(value) := num value := IF decimal places = 0
              THEN
                num value * base + digit
              ELSE
                decimal places *:= base;
                num value + digit / decimal places
              FI
          FI
        ELIF token = "." THEN
          decimal places := 1
        ELSE
          SKIP # and ignore spaces and any unrecognised characters #
        FI
      ),
      (MONADIC): SKIP, # not implemented #
      (DIADIC):(
        value := compress ast stack(prio OF this op, value);
        IF top=UPB stack THEN index error FI;
        stack[top+:=1]:=STACKITEM(value, this op);
        value:=NIL
      )
    ESAC
  OD;
  compress ast stack(-max int, value)
);

test:(
   printf(($" euler's number is about: "g(-long real width,long real width-2)l$,
     EVAL build ast("1+1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+(1+1/15)/14)/13)/12)/11)/10)/9)/8)/7)/6)/5)/4)/3)/2")));
  SKIP EXIT
  index error:
    printf(("Stack over flow"))
)
