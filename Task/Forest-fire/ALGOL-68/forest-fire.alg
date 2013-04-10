LONG REAL tree prob = 0.55, # original tree probability #
          f prob =    0.01, # new combustion probability #
          p prob =    0.01; # tree creation probability #
MODE CELL = CHAR; CELL empty=" ", tree="T", burning="#";
MODE WORLD = [6, 65]CELL;

PROC has burning neighbours = (WORLD world, INT r, c)BOOL:(
  FOR row shift FROM -1 TO 1 DO
    FOR col shift FROM -1 TO 1 DO
      INT rs = r + row shift, cs = c + col shift;
      IF rs >= LWB world AND rs <= UPB world AND
          cs >= 2 LWB world AND cs <= 2 UPB world THEN
        IF world[rs, cs] = burning THEN true exit FI
      FI
    OD
  OD;
  FALSE EXIT
  true exit: TRUE
);

PROC next state = (REF WORLD world, REF WORLD next world)VOID:(
  FOR r FROM LWB world TO UPB world DO
    REF[]CELL row = world[r, ];
    FOR c FROM LWB row TO UPB row DO
      REF CELL elem = row[c];
      next world[r, c] :=
        IF elem = empty THEN
          IF random<p prob THEN tree ELSE empty FI
        ELIF elem = tree THEN
          IF has burning neighbours(world, r, c) THEN
            burning
          ELSE
            IF random<f prob THEN burning ELSE tree FI
          FI
        ELIF elem = burning THEN
          empty
        FI
    OD
  OD;
  world := next world
);

main:(
  WORLD world; # create world #
  FOR r FROM LWB world TO UPB world DO
    REF []CELL row = world[r, ];
    FOR i FROM LWB row TO UPB row DO
      REF CELL el = row[i];
      el := IF random < tree prob THEN tree ELSE empty FI
    OD
  OD;

  WORLD next world;
  FOR i FROM 0 TO 4 DO
    next state(world, next world);
    printf(($n(2 UPB world)(a)l$, world)); # show world #
    printf(($gl$, 2 UPB world * "-"))
  OD
)
