COMMENT
  Define an general event handling mechanism on MODE OBJ:
  * try to parallel pythons exception handling flexibility
END COMMENT

COMMENT
  REQUIRES:
    MODE OBJ # These can be a UNION of REF types #
    OP OBJIS
  PROVIDES:
    OP ON, RAISE, RESET
    PROC obj on, obj raise, obj reset
END COMMENT

# define object related to OBJ EVENTS #
MODE
  RAISEOBJ = PROC(OBJ)VOID, RAWMENDOBJ = PROC(OBJ)BOOL,
  MENDOBJ = UNION(RAWMENDOBJ, PROC VOID), # Generalise: Allow PROC VOID (a GOTO) as a short hand #
  NEWSCOPEOBJ = STRUCT(REF NEWSCOPEOBJ up, FLEXOBJ obj flex, FLEXEVENTOBJ event flex, MENDOBJ mended),
  SCOPEOBJ = REF NEWSCOPEOBJ;

MODE FLEXOBJ=FLEX[0]OBJ;

# Provide an INIT to convert a GO TO to a MEND ... useful for direct aborts #
OP INITMENDOBJ = (PROC VOID go to)MENDOBJ: (go to; SKIP);

SCOPEOBJ obj scope end = NIL;
SCOPEOBJ obj scope begin := obj scope end; # INITialise stack #
OBJ obj any = EMPTY;
EVENTOBJ obj event any = NIL;

# Some crude Singly Linked-List manipulations of the scopes, aka stack ... #
# An event/mended can be shared for all OBJ of the same type: #
PRIO INITAB = 1, +=: = 1;
OP INITAB = (SCOPEOBJ lhs, MENDOBJ obj mend)SCOPEOBJ:
  lhs := (obj scope end, obj any, obj event any, obj mend);

OP INITSCOPE = (MENDOBJ obj mend)SCOPEOBJ: HEAP NEWSCOPEOBJ INITAB obj mend;
OP +=: = (SCOPEOBJ item, REF SCOPEOBJ rhs)SCOPEOBJ: ( up OF item := rhs; rhs := item );
OP +=: = (MENDOBJ mend, REF SCOPEOBJ rhs)SCOPEOBJ: INITSCOPE mend +=: rhs;
#OP -=: = (REF SCOPEOBJ scope)SCOPEOBJ: scope := up OF scope;#

COMMENT Restore the prio event scope: ~ END COMMENT
PROC obj reset = (SCOPEOBJ up scope)VOID: obj scope begin := up scope;
MENDOBJ obj unmendable = (OBJ obj)BOOL: FALSE;

MODE NEWEVENTOBJ = STRUCT( # the is simple a typed place holder #
  SCOPEOBJ scope,
  STRING description,
  PROC (OBJ #obj#, MENDOBJ #obj mend#)SCOPEOBJ on,
  PROC (OBJ #obj#, STRING #msg#)VOID raise
), EVENTOBJ = REF NEWEVENTOBJ;

MODE FLEXEVENTOBJ = FLEX[0]EVENTOBJ;

COMMENT Define how to catch an event:
    obj - IF obj IS NIL then mend event on all OBJects
    obj mend - PROC to call to repair the object
    return the prior event scope
END COMMENT
PROC obj on = (FLEXOBJ obj flex, FLEXEVENTOBJ event flex, MENDOBJ mend)SCOPEOBJ: (
  mend +=: obj scope begin;
  IF obj any ISNTIN obj flex THEN obj flex OF obj scope begin := obj flex FI;
  IF obj event any ISNTIN event flex THEN event flex OF obj scope begin := event flex FI;
  up OF obj scope begin
);

PRIO OBJIS = 4, OBJISNT = 4; # pick the same PRIOrity as EQ and NE #
OP OBJISNT = (OBJ a,b)BOOL: NOT(a OBJIS b);

PRIO ISIN = 4, ISNTIN = 4;
OP ISNTIN = (OBJ obj, FLEXOBJ obj flex)BOOL: (
  BOOL isnt in := FALSE;
  FOR i TO UPB obj flex WHILE isnt in := obj OBJISNT obj flex[i] DO SKIP OD;
  isnt in
);
OP ISIN = (OBJ obj, FLEXOBJ obj flex)BOOL: NOT(obj ISNTIN obj flex);

OP ISNTIN = (EVENTOBJ event, FLEXEVENTOBJ event flex)BOOL: (
  BOOL isnt in := TRUE;
  FOR i TO UPB event flex WHILE isnt in := event ISNT event flex[i] DO SKIP OD;
  isnt in
);
OP ISIN = (EVENTOBJ event, FLEXEVENTOBJ event flex)BOOL: NOT(event ISNTIN event flex);

COMMENT Define how to raise an event, once it is raised try and mend it:
  if all else fails produce an error message and stop
END COMMENT
PROC obj raise = (OBJ obj, EVENTOBJ event, STRING msg)VOID:(
  SCOPEOBJ this scope := obj scope begin;
# until mended this event should cascade through scope event handlers/members #
  FOR i WHILE this scope ISNT SCOPEOBJ(obj scope end) DO
    IF (obj any ISIN obj flex OF this scope OR obj ISIN obj flex OF this scope ) AND
       (obj event any ISIN event flex OF this scope OR event ISIN event flex OF this scope)
    THEN
      CASE mended OF this scope IN
        (RAWMENDOBJ mend):IF mend(obj) THEN break mended FI,
        (PROC VOID go to): (go to; stop)
      OUT put(stand error, "undefined: raise stop"); stop
      ESAC
    FI;
    this scope := up OF this scope
  OD;
  put(stand error, ("OBJ event: ",msg)); stop; FALSE
EXIT
  break mended: TRUE
);

CO define ON and some useful(?) RAISE OPs CO
PRIO ON = 1, RAISE = 1;
OP ON = (MENDOBJ mend, EVENTOBJ event)SCOPEOBJ: obj on(obj any, event, mend),
   RAISE = (OBJ obj, EVENTOBJ event)VOID: obj raise(obj, event, "unnamed event"),
   RAISE = (OBJ obj, MENDOBJ mend)VOID: ( mend ON obj event any; obj RAISE obj event any),
   RAISE = (EVENTOBJ event)VOID: obj raise(obj any, event, "unnamed event"),
   RAISE = (MENDOBJ mend)VOID: ( mend ON obj event any; RAISE obj event any),
   RAISE = (STRING msg, EVENTOBJ event)VOID: obj raise(obj any, event, msg);
OP (SCOPEOBJ #up scope#)VOID RESET = obj reset;

SKIP
