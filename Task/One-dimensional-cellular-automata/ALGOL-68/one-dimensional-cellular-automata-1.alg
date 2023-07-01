INT stop generation = 9;
INT universe width = 20;
FORMAT alive or dead = $b("#","_")$;

BITS universe := 2r01110110101010100100;
   # universe := BIN ( ENTIER ( random * max int ) ); #
INT upb universe = bits width;
INT lwb universe = bits width - universe width + 1;

PROC couple = (BITS parent, INT lwb, upb)BOOL: (
  SHORT INT sum := 0;
  FOR bit FROM lwb TO upb DO
    sum +:= ABS (bit ELEM parent)
  OD;
  sum = 2
);

FOR generation FROM 0 WHILE
  printf(($"Generation "d": "$, generation,
         $f(alive or dead)$, []BOOL(universe)[lwb universe:upb universe],
         $l$));
# WHILE # generation < stop generation DO
  BITS next universe := 2r0;

  # process the first event horizon manually #
  IF couple(universe,lwb universe,lwb universe + 1) THEN
    next universe := 2r10
  FI;

  # process the middle kingdom in a loop #
  FOR bit FROM lwb universe + 1 TO upb universe - 1 DO
    IF couple(universe,bit-1,bit+1) THEN
      next universe := next universe OR 2r1
    FI;
    next universe := next universe SHL 1
  OD;

  # process the last event horizon manually #
  IF couple(universe, upb universe - 1, upb universe) THEN
    next universe := next universe OR 2r1
  FI;
  universe := next universe
OD
