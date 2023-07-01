MODE YIELDVALUE = PROC(VALUE)VOID;
MODE GENVALUE = PROC(YIELDVALUE)VOID;

PROC gen filtered = (GENVALUE gen candidate, gen exclude, YIELDVALUE yield)VOID: (
    VALUE candidate; SEMA have next exclude = LEVEL 0;
    VALUE exclude;   SEMA get next exclude  = LEVEL 0;
    BOOL initialise exclude := TRUE;

    PAR ( # run each generator in a different thread #
# Thread 1 #
      # FOR VALUE next exclude IN # gen exclude( # ) DO #
      ##   (VALUE next exclude)VOID: (
            DOWN get next exclude; exclude := next exclude;
            IF candidate <= exclude THEN
                UP have next exclude
            ELSE
                UP get next exclude
            FI
      # OD #)),
# Thread 2 #
      # FOR VALUE next candidate IN # gen candidate( # ) DO #
      ##   (VALUE next candidate)VOID: (
            candidate := next candidate;
            IF initialise exclude ORF candidate > exclude THEN
                UP get next exclude;
                DOWN have next exclude; # wait for result #
                initialise exclude := FALSE
            FI;
            IF candidate < exclude THEN
                yield(candidate)
            FI
      # OD #))
    )
);

PROC gen slice = (GENVALUE t, VALUE start, stop, YIELDVALUE yield)VOID: (
  INT index := 0;
  # FOR VALUE i IN # t( # ) DO #
  ##   (VALUE i)VOID: (
      IF   index >= stop THEN done
      ELIF index >= start THEN yield(i) FI;
      index +:= 1
  # OD # ));
    done: SKIP
);

PROC get list = (GENVALUE gen)[]VALUE: (
    INT upb := 0;
    INT ups := 2;
    FLEX [ups]VALUE out;
  # FOR VALUE i IN # gen( # ) DO #
  ##   (VALUE i)VOID:(
        upb +:= 1;
        IF upb > ups THEN # dynamically grow the array 50% #
          [ups +:= ups OVER 2]VALUE append; append[:upb-1] := out; out := append
        FI;
        out[upb] := i
  # OD # ))
    out[:upb]
);

PROC powers = (VALUE m, YIELDVALUE yield)VOID:
    FOR n FROM 0 DO yield(n ** m) OD;
