# -*- coding: utf-8 -*- #

INT trit width = 1, trit base = 3;
MODE TRIT = STRUCT(BITS trit);
CO FORMAT trit fmt = $c("?","⌈","⌊",#|"~"#)$; CO

# These values treated are as per "Balanced ternary" #
# eg true=1, maybe=0, false=-1 #
TRIT true =INITTRIT 4r1, maybe=INITTRIT 4r0,
     false=INITTRIT 4r2;

# Warning: redefines standard builtins flip & flop #
LONGCHAR flap="?", flip="⌈", flop="⌊";

OP REPR = (TRIT t)LONGCHAR:
  []LONGCHAR(flap, flip, flop)[1+ABS trit OF t];

############################################
# Define some OPerators for coercing MODES #
############################################
OP INITTRIT = (BOOL in)TRIT:
  (in|true|false);

OP INITBOOL = (TRIT in)BOOL:
  (trit OF in=trit OF true|TRUE|:trit OF in=trit OF false|FALSE|
    raise value error(("vague TRIT to BOOL coercion: """, REPR in,""""));~
  );
OP B = (TRIT in)BOOL: INITBOOL in;

# These values treated are as per "Balanced ternary" #
# n.b true=1, maybe=0, false=-1 #
# Warning: BOOL ABS FALSE (0) is not the same as TRIT ABS false (-1) #

OP INITINT = (TRIT t)INT:
  CASE 1+ABS trit OF t
  IN #maybe# 0, #true # 1, #false#-1
  OUT raise value error(("invalid TRIT value",REPR t)); ~
  ESAC;

OP INITTRIT = (INT in)TRIT: (
  TRIT out;
  trit OF out:= trit OF
    CASE 2+in
    IN false, maybe, true
    OUT raise value error(("invalid TRIT value",in)); ~
    ESAC;
  out
);

OP INITTRIT = (BITS b)TRIT:
  (TRIT out; trit OF out:=b; out);

##################################################
# Define the LOGICAL OPerators for the TRIT MODE #
##################################################
MODE LOGICAL = TRIT;
PR READ "Template_operators_logical_mixin.a68" PR

COMMENT
  Kleene logic truth tables:
END COMMENT

OP AND = (TRIT a,b)TRIT: (
  [,]TRIT(
    # ∧  ##  false, maybe, true  #
    #false# (false, false, false),
    #maybe# (false, maybe, maybe),
    #true # (false, maybe, true )
  )[@-1,@-1][INITINT a, INITINT b]
);

OP OR = (TRIT a,b)TRIT: (
  [,]TRIT(
    # ∨  ##  false, maybe, true #
    #false# (false, maybe, true),
    #maybe# (maybe, maybe, true),
    #true # (true,  true,  true)
  )[@-1,@-1][INITINT a, INITINT b]
);

PRIO IMPLIES = 1; # PRIO = 1.9 #
OP IMPLIES = (TRIT a,b)TRIT: (
  [,]TRIT(
    # ⊃   ## false, maybe, true #
    #false# (true,  true,  true),
    #maybe# (maybe, maybe, true),
    #true # (false, maybe, true)
  )[@-1,@-1][INITINT a, INITINT b]
);

PRIO EQV = 1; # PRIO = 1.8 #
OP EQV = (TRIT a,b)TRIT: (
  [,]TRIT(
    # ≡   ## false, maybe, true #
    #false# (true,  maybe, false),
    #maybe# (maybe, maybe, maybe),
    #true # (false, maybe, true )
  )[@-1,@-1][INITINT a, INITINT b]
);
