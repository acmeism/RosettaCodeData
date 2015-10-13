#!/usr/bin/a68g --script #

MODE OBJ=UNION(REF INT, REF REAL, REF STRING,# etc # VOID);

OP OBJIS = (OBJ a,b)BOOL: # Are a and b at the same address? #
  CASE a IN # Ironically Algol68's STRONG typing means we cannot simply compare addresses #
    (REF INT a): a IS (b|(REF INT b):b|NIL),
    (REF REAL a): a IS (b|(REF REAL b):b|NIL),
    (REF STRING a): a IS (b|(REF STRING b):b|NIL)
  OUT FALSE
  ESAC;

PR READ "prelude/event_base(obj).a68" PR;
NEWEVENTOBJ obj eventa := SKIP;
NEWEVENTOBJ obj eventb := SKIP;
NEWEVENTOBJ user defined exception := SKIP;

# An event can be continued "mended" or break "unmended" #
PROC found sum sqs continue = (OBJ obj)BOOL: ( print("."); TRUE); # mended #
PROC found sum sqs break = (OBJ obj)BOOL: (found sq sum sqs; FALSE); # unmended #

INT sum sqs:=0;
REAL x:=111, y:=222, z:=333;

SCOPEOBJ obj scope reset := obj on((sum sqs, x,y,z), (obj eventa,obj eventb), VOID:found sq sum sqs);

# An event handler specific to the specific object instance: #
#SCOPEOBJ obj scope reset := obj on eventb(sum sqs, VOID:found sq sum sqs);#

# Or... An "obj any" event handler: #
# SCOPEOBJ obj scope reset := found sum sqs break ON obj eventb; #

# Raise the "event eventb" on an object: #
  FOR i DO
    sum sqs +:= i*i;
    IF sum sqs = 70*70 THEN # 1st try to use an instance specific mend on the object #
      obj raise(sum sqs, obj eventb, "Found a sq sum of sqs") FI; # OR ... #
    IF sum sqs = 70*70 THEN "Found a sq sum of sqs" RAISE obj eventb FI; # OR ... #
    IF sum sqs = 70*70 THEN RAISE found sum sqs break FI # simplest #
  OD;
  RESET obj scope reset # need to manually reset back to prior handlers #

# Catch "event eventb": #
EXIT found sq sum sqs:
  print(("sum sqs:",sum sqs, new line)); # event eventb caught code here ... #
  RESET obj scope reset;

  "finally: raise the base unmendable event" RAISE obj eventb
