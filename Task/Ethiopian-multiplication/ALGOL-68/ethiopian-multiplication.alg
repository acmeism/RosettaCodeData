PROC halve = (REF INT x)VOID: x := ABS(BIN x SHR 1);
PROC doublit = (REF INT x)VOID: x := ABS(BIN x SHL 1);
PROC iseven = (#CONST# INT x)BOOL: NOT ODD x;

PROC ethiopian = (INT in plier,
              INT in plicand, #CONST# BOOL tutor)INT:
(
  INT plier := in plier, plicand := in plicand;
  INT result:=0;

  IF tutor THEN
    printf(($"ethiopian multiplication of "g(0)," by "g(0)l$, plier, plicand)) FI;

  WHILE plier >= 1 DO
    IF iseven(plier) THEN
      IF tutor THEN printf(($" "4d,"  "6d" struck"l$, plier, plicand)) FI
    ELSE
      IF tutor THEN printf(($" "4d,"  "6d" kept"l$, plier, plicand)) FI;
      result +:= plicand
    FI;
    halve(plier); doublit(plicand)
  OD;
  result
);

main:
(
  printf(($g(0)l$, ethiopian(17, 34, TRUE)))
)
