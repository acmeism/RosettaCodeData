PROC report = (REF FILE file in)INT: (

  MODE TIME = [19]CHAR;
  STRUCT ([3]CHAR inout, TIME time, INT jobnum) record;
  FORMAT record fmt = $"License "g" @ "g" for job "g(0)l$;

  FLEX[1]TIME max time;

  INT lic out := 0, max out := LWB max time-1, max count := LWB max time-1;
  BOOL file in ended := FALSE;
  on logical file end(file in, (REF FILE file in)BOOL: file in ended := TRUE);
  WHILE
    getf(file in, (record fmt, record));
# WHILE # NOT file in ended DO
    IF inout OF record = "OUT" THEN
      lic out +:= 1
    ELIF lic out > 0 THEN # incase license already "OUT" #
      lic out -:= 1
    FI;

    IF lic out > max out THEN
      max out := lic out;
      max count := LWB max time-1
    FI;
    IF lic out = max out THEN
      IF max count = UPB max time THEN
        [UPB max time*2]TIME new max time;
        new max time[:UPB max time] := max time;
        max time := new max time
        # ;putf(stand error, ($"increasing UPB max time (now it is "g(0)")"l$, UPB max time)); #
      FI;
      max time[max count +:= 1] := time OF record
    FI
  OD;

  printf(($"Maximum simultaneous license use is "g(0)" at the following times:"l$, max out));
  FOR lic out FROM LWB max time TO max count DO
    printf(($gl$, max time[lic out]))
  OD;

  0 EXIT
  exit report error: errno
);

INT errno;

COMMENT
  Usage:
    a68g Text_processing_3.a68 --exit Text_processing_3.dat
    a68g Text_processing_3.a68 < Text_processing_3.dat
END COMMENT

main:
(
  INT argv1 := 4;
  IF argc >= argv1 THEN
    FOR i FROM argv1 TO argc DO
      FILE file in;
      errno := open(file in, argv(i), stand in channel);
      IF errno /= 0 THEN
        putf(stand error, ($"cannot read "gl$, argv(1)));
        exit main error
      ELSE
        report(file in)
      FI;
      close(file in)
    OD
  ELSE
    report(stand in)
  FI;
  exit main error: SKIP
)
