# -*- coding: utf-8 -*- #

COMMENT
  REQUIRES :
    MODE EXCEPTOBJ = UNION(VOID, MODEA, MODEB, MODEC ...);
    OP FIRMSTR = (EXCEPTOBJ obj)STRING: ~
END COMMENT

MODE EXCEPTOBJS = [0]EXCEPTOBJ;

OP STR = (EXCEPTOBJS obj)STRING: (
  STRING out := "(", fs := "";
  FOR this FROM LWB obj TO UPB obj DO out +:= fs+FIRMSTR obj[this]; fs:=", " OD;
  out +")"
);

MODE EXCEPTMEND = PROC(EXCEPTOBJS #obj#,STRING #msg#)BOOL;

PROC super mend = (EXCEPTOBJS obj,STRING sub exception, msg)BOOL:
  ( put(stand error, ("exception/",sub exception,": ", msg," - ", STR obj, new line)); break; TRUE);

PROC super break mend = (EXCEPTOBJS obj,STRING sub exception, msg)BOOL: ( super mend(obj, sub exception, msg); break; TRUE);
PROC super stop mend = (EXCEPTOBJS obj,STRING sub exception, msg)BOOL: ( super mend(obj, sub exception, msg); stop; FALSE);
PROC super ignore mend = (EXCEPTOBJS obj,STRING sub exception, msg)BOOL: ( #super mend(obj, sub exception, msg);# TRUE);

EXCEPTMEND on undefined mend := super break mend(,"undefined",);
PROC on undefined = (EXCEPTMEND undefined mend)VOID: on undefined mend := undefined mend;
PROC raise undefined = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on undefined mend(obj, msg) THEN stop FI;

EXCEPTMEND on value error mend := super break mend(,"value error",);
PROC on value error = (EXCEPTMEND value error mend)VOID: on value error mend := value error mend;
PROC raise value error = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on value error mend(obj, msg) THEN stop FI;

EXCEPTMEND on bounds error mend := super break mend(,"bounds error",);
PROC on bounds error = (EXCEPTMEND bounds error mend)VOID: on bounds error mend := bounds error mend;
PROC raise bounds error = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on bounds error mend(obj, msg) THEN stop FI;

EXCEPTMEND on tagged union error mend := super break mend(,"tagged union error",);
PROC on tagged union error = (EXCEPTMEND tagged union error mend)VOID: on tagged union error mend := tagged union error mend;
PROC raise tagged union error = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on tagged union error mend(obj, msg) THEN stop FI;

EXCEPTMEND on untested mend := super break mend(,"untested",);
PROC on untested = (EXCEPTMEND untested mend)VOID: on untested mend := untested mend;
PROC raise untested = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on untested mend(obj, msg) THEN stop FI;

EXCEPTMEND on unimplemented mend := super break mend(,"unimplemented",);
PROC on unimplemented = (EXCEPTMEND unimplemented mend)VOID: on unimplemented mend := unimplemented mend;
PROC raise unimplemented = (EXCEPTOBJS obj, STRING msg)VOID: IF NOT on unimplemented mend(obj, msg) THEN stop FI;

SKIP
