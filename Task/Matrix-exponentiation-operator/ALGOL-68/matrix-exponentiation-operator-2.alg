OP ** = (MAT base, INT exponent)MAT: (
  BITS binary exponent:=BIN exponent ;
  MAT out := IF bits width ELEM binary exponent THEN base ELSE IDENTITY UPB base FI;
  MAT sq:=base;

  WHILE
    binary exponent := binary exponent SHR 1;
    binary exponent /= BIN 0
  DO
    sq := sq * sq;
    IF bits width ELEM binary exponent THEN out := out * sq FI
  OD;
  out
);
