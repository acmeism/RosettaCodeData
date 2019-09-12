INT stop generation = 9;
INT upb universe = 20;
FORMAT alive or dead = $b("#","_")$;

BITS bits universe := 2r01110110101010100100;
   # bits universe := BIN ( ENTIER ( random * max int ) ); #
[upb universe] BOOL universe := []BOOL(bits universe)[bits width - upb universe + 1:];

PROC couple = (REF[]BOOL parent)BOOL: (
  SHORT INT sum := 0;
  FOR bit FROM LWB parent TO UPB parent DO
    sum +:= ABS (parent[bit])
  OD;
  sum = 2
);

FOR generation FROM 0 WHILE
  printf(($"Generation "d": "$, generation,
         $f(alive or dead)$, universe,
         $l$));
# WHILE # generation < stop generation DO
  [UPB universe]BOOL next universe;

  # process the first event horizon manually #
  next universe[1] := couple(universe[:2]);

  # process the middle kingdom in a loop #
  FOR bit FROM LWB universe + 1 TO UPB universe - 1 DO
    next universe[bit] := couple(universe[bit-1:bit+1])
  OD;

  # process the last event horizon manually #
  next universe[UPB universe] := couple(universe[UPB universe - 1: ]);
  universe := next universe
OD
