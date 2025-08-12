# some char/string utilities: #

OP UC = (CHAR ch) CHAR:
  IF ch >= "a" AND ch <= "z" THEN REPR (ABS ch - 32) ELSE ch FI;
OP UC = (STRING s) STRING: (
    [UPB s]CHAR res;
    FOR i TO UPB s DO res[i] := UC s[i] OD;
    res);
OP LC = (CHAR ch) CHAR: IF ch >= "A" AND ch <= "Z" THEN REPR (ABS ch + 32) ELSE ch FI;
OP LC = (STRING s) STRING: (
    [UPB s]CHAR res;
    FOR i TO UPB s DO res[i] := LC s[i] OD;
    res);
OP INDEXOF = ([]STRING ss, STRING s) INT: (
  INT idx := LWB ss - 1;
  FOR i FROM LWB ss TO UPB ss DO
    IF s = ss[i] THEN idx := i; break FI
  OD;
  break:
  idx);
PRIO INDEXOF = 7;

# date manipulation utilities: #

MODE DATE = STRUCT ([6]INT d, STRING tz);

MODE TZOFFSET = STRUCT (STRING tz, [3]INT offset);

# add freely #
[]TZOFFSET tz offsets = (("EST", (-5, 0, 0)), ("", (0,0,0)), ("UTC", (0,0,0)), ("NPT", (5, 45, 0)));

OP INDEXOF = ([]TZOFFSET tzos, STRING s) INT: (
  INT idx := LWB tzos - 1;
  FOR i FROM LWB tzos TO UPB tzos DO
    IF s = tz OF tzos[i] THEN idx := i; break FI
  OD;
  break:
  idx);

PROC is leap year = (INT year) BOOL:
  year %* 400 = 0 OR year %* 4 = 0 AND year %* 100 ~= 0;

PROC days in month = (INT month, year) INT:
  CASE month IN 31, (is leap year(year) | 29 | 28), 31, 30, 31, 30,
                31, 31, 30, 31, 30, 31
  ESAC;

# makes sure all numbers are in the right ranges. f.i., to get the last day of a month,
  make a date with day 0 of the next month and call this routine #
PROC normalize date = (REF DATE date) VOID:
  BEGIN
    PROC fix = (REF INT unit, INT limit, REF INT next) VOID:
      IF unit < 0 OR unit >= limit THEN
        INT adj = (unit < 0 | 1 | 0);
        next +:= unit % limit - adj; unit %*:= limit
      FI;
    INT year = 1, month = 2, day = 3, hour = 4, minute = 5, second = 6;
    REF []INT d := (d OF date);
    fix(d[second], 60, d[minute]); fix(d[minute], 60, d[hour]);
    fix(d[hour], 24, d[day]);
    IF d[month] < 1 OR d[month] > 12 THEN
      INT adj = (d[month] < 1 | 1 | 0);
      d[year] +:= (d[month]-1) % 12 - adj; d[month] := (d[month]-1) %* 12 + 1
    FI;
    WHILE d[day] > days in month(d[month], d[year]) DO
      d[day] -:= days in month(d[month], d[year]);
      d[month] +:= 1;
      IF d[month] > 12 THEN d[year] +:= 1; d[month] := 1 FI
    OD;
    WHILE d[day] < 1 DO
      IF d[month] = 1 THEN d[month] := 12; d[year] -:= 1 ELSE d[month] -:= 1 FI;
      d[day] +:= days in month(d[month], d[year])
    OD
  END;

# interval: y[, m[, d[, h[, M[, s]]]]] #
PROC date add = (DATE d, []INT interval) DATE: (
  DATE result := d;
  FOR i FROM LWB interval TO UPB interval DO
    (d OF result)[i - LWB interval + 1] +:= interval[i]
  OD;
  normalize date(result);
  result);

# interval: [[[[[y,] m,] d,] h,] M,] s #
PROC time add = (DATE d, []INT interval) DATE: (
  DATE result := d;
  FOR i FROM LWB interval TO UPB interval DO
    (d OF result)[i - UPB interval + 6] +:= interval[i]
  OD;
  normalize date(result);
  result);

# this datetime in a different time zone #
PROC in tz = (DATE d, STRING new tz) DATE:
  IF
    INT idx current = tz offsets INDEXOF tz OF d;
    INT idx new     = tz offsets INDEXOF new tz;
    idx current < 1 OR idx new < 1
  THEN
    d
  ELSE
    [3]INT current offset := offset OF tz offsets[idx current];
    [] INT new offset      = offset OF tz offsets[idx new];
    FOR i TO UPB current offset DO
      current offset[i] := -current offset[i]
    OD;
    DATE result := time add(time add(d, current offset), new offset);
    tz OF result := tz OF tz offsets[idx new];
    result
  FI;

# canonical representation of a date (SQL-style with optional time zone) #
OP REPR = (DATE d) STRING: (
  STRING buf; FILE f; associate(f, buf);
  putf(f, ($4d,"-"2d,"-"2d," "2d,":"2d,":"2d$, d OF d));
  IF tz OF d ~= "" THEN put(f, (" ", tz OF d)) FI;
  close(f);
  buf);


[]STRING month names = ("January", "February", "March", "April", "May", "June", "July",
                        "August", "September", "October", "November", "December");

# default for h:m:s is 0:0:0. there's no default for year, month or day #
PROC parse date = (STRING s, STRING fmt, REF DATE result) BOOL:
  BEGIN
    INT idx;
    PROC at end = BOOL: idx > UPB s;
    PROC skip spaces = VOID:
      IF at end THEN error
      ELIF s[idx] ~= " " THEN error
      ELSE WHILE IF at end THEN FALSE ELSE s[idx] = " " FI DO idx +:= 1 OD
      FI;
    PROC read number = (INT min digits, max digits, min value, max value) INT:
      BEGIN
        IF at end THEN error
        ELSE
          INT md = IF prefix = "-" THEN min digits ELSE max digits FI;
          INT n := 0, digits := 0;
          WHILE IF at end THEN FALSE ELSE s[idx] >= "0" AND s[idx] <= "9" FI DO
            n := n * 10 + (ABS s[idx] - ABS "0");
            digits +:= 1;
            idx +:= 1
          OD;
          IF n < min value OR n > max value OR digits < md OR digits > max digits THEN error FI;
          n
        FI
      END;
    PROC read alpha = STRING:
      IF at end THEN error
      ELSE
        INT start = idx;
        WHILE IF at end THEN FALSE ELSE UC s[idx] >= "A" AND UC s[idx] <= "Z" FI DO idx +:= 1 OD;
        IF start = idx THEN error ELSE s[start : idx-1] FI
      FI;
    PROC read month name = INT:
      BEGIN
        STRING m := read alpha;
        m[1] := UC m[1]; m[2:] := LC m[2:];
        INT res = month names INDEXOF m;
        IF res < 1 THEN error FI;
        res
      END;
    PROC match = (CHAR ch) VOID:
      IF at end THEN error
      ELIF s[idx] ~= ch THEN error
      ELSE idx +:= 1
      FI;
    PROC no prefix = VOID: IF prefix ~= " " THEN error FI;

    INT year = 1, month = 2, day = 3, hour = 4, minute = 5, second = 6;
    result := ((-1, -1, -1, 0, 0, 0), "");

    BOOL percent := FALSE, skip := FALSE;
    CHAR prefix := " ", ampm := " ";
    idx := 1;
    FOR i FROM LWB fmt TO UPB fmt DO
      CHAR ch = fmt[i];
      IF percent THEN
        IF ch = "-" THEN no prefix; prefix := "-"
        ELSE
          IF skip THEN skip spaces; skip := FALSE FI;
          IF   ch = "%" THEN no prefix; match("%")
          ELIF ch = "Y" THEN no prefix; (d OF result)[year] := read number(4, 4, 1, 9999)
          ELIF ch = "B" THEN no prefix; (d OF result)[month] := read month name
          ELIF ch = "m" THEN            (d OF result)[month] := read number(1, 2, 1, 12)
          ELIF ch = "d" THEN            (d OF result)[day] := read number(1, 2, 1, 31)
          ELIF ch = "H" THEN            (d OF result)[hour] := read number(1, 2, 0, 23)
          ELIF ch = "I" THEN            (d OF result)[hour] := -read number(1, 2, 1, 12)
          ELIF ch = "M" THEN            (d OF result)[minute] := read number(1, 2, 0, 59)
          ELIF ch = "S" THEN            (d OF result)[second] := read number(1, 2, 0, 59)
          ELIF ch = "p" THEN no prefix; STRING ap = read alpha;
                             IF ap = "am" THEN ampm := "a" ELIF ap = "pm" THEN ampm := "p"
                             ELSE error FI
          ELIF ch = "Z" THEN no prefix; (tz OF result) := read alpha
          ELSE error
          FI;
          prefix := " "; percent := FALSE
        FI
      ELSE
        IF   ch = " " THEN skip := TRUE
        ELIF ch = "%" THEN percent := TRUE
        ELSE
          IF skip THEN skip spaces; skip := FALSE FI;
          match(ch)
        FI
      FI
    OD;
    IF skip OR percent THEN error FI;
    IF (d OF result)[hour] < 0 THEN
      INT h = -(d OF result)[hour];
      (d OF result)[hour] := IF ampm = "p" THEN h %* 12 + 12 ELSE h %* 12 FI
    ELIF ampm ~= " " THEN error
    FI;
    FOR i TO 6 DO IF (d OF result)[i] < 0 THEN error FI OD;
    normalize date(result);
    TRUE EXIT
    error: FALSE
  END;

# finally, the task: #

STRING string = "March 7 2009 7:30pm EST";
DATE date;
BOOL ok = parse date(string, "%B %-d %Y %-I:%M%p %Z", date);

print(("The string """, string, """", new line));

IF ok THEN
  print(("       represents the date ", REPR date, new line));
  DATE later = time add(date, (12, 0, 0));
  print(("       12 hours later it's ", REPR later, new line));
  print(("(the same moment in Nepal: ", REPR in tz(later, "NPT"), ")", new line))
ELSE
  print(("        doesn't represent any date this program can parse :(", new line))
FI
