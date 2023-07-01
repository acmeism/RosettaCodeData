MODE GENMODE = STRING;

GENMODE v1:="Francis Gary Powers", v2:="Vilyam Fisher";

PRIO =:= = 1;

OP =:= = (REF GENMODE v1, v2)VOID: (
  GENMODE tmp:=v1; v1:=v2; v2:=tmp
);

v1 =:= v2;

print(("v1: ",v1, ", v2: ", v2, new line))
