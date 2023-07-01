INT no data := 0;               # Current run of consecutive flags<0 in lines of file #
INT no data max := -1;          # Max consecutive flags<0 in lines of file #
FLEX[0]STRING no data max line; # ... and line number(s) where it occurs #

REAL tot file := 0;             # Sum of file data #
INT num file := 0;              # Number of file data items with flag>0 #

# CHAR fs = " "; #
INT nf = 24;

INT upb list := nf;
FORMAT list repr = $n(upb list-1)(g", ")g$;

PROC exception = ([]STRING args)VOID:(
  putf(stand error, ($"Exception"$, $", "g$, args, $l$));
  stop
);

PROC raise io error = (STRING message)VOID:exception(("io error", message));

OP +:= = (REF FLEX []STRING rhs, STRING append)REF FLEX[]STRING: (
  HEAP [UPB rhs+1]STRING out rhs;
  out rhs[:UPB rhs] := rhs;
  out rhs[UPB rhs+1] := append;
  rhs := out rhs;
  out rhs
);

INT upb opts = 3; # these are "a68g" "./Data_Munging.a68" & "-" #
[argc - upb opts]STRING in files;
FOR arg TO UPB in files DO in files[arg] := argv(upb opts + arg) OD;

MODE FIELD = STRUCT(REAL data, INT flag);
FORMAT field repr = $2(g)$;

FOR index file TO UPB in files DO
  STRING file name = in files[index file], FILE file;
  IF open(file, file name, stand in channel) NE 0 THEN
    raise io error("Cannot open """+file name+"""") FI;
  on logical file end(file, (REF FILE f)BOOL: logical file end done);
  REAL tot line, INT num line;
  # make term(file, ", ") for CSV data #
  STRING date;
  DO
    tot line := 0;             # sum of line data #
    num line := 0;             # number of line data items with flag>0 #
    # extract field info #
    [nf]FIELD data;
    getf(file, ($10a$, date, field repr, data, $l$));

    FOR key TO UPB data DO
      FIELD field = data[key];
      IF flag OF field<1 THEN
        no data +:= 1
      ELSE
        # check run of data-absent data #
        IF no data max = no data AND no data>0 THEN
          no data max line +:= date FI;
        IF no data max<no data AND no data>0 THEN
          no data max := no data;
          no data max line := date FI;
        # re-initialise run of no data counter #
        no data := 0;
        # gather values for averaging #
        tot line +:= data OF field;
        num line +:= 1
      FI
    OD;

    # totals for the file so far #
    tot file +:= tot line;
    num file +:= num line;

    printf(($"Line: "g"  Reject: "g(-2)"  Accept: "g(-2)"  Line tot: "g(-14, 3)"  Line avg: "g(-14, 3)l$,
          date,
          UPB(data) -num line,
          num line, tot line,
          IF num line>0 THEN tot line/num line ELSE 0 FI))
  OD;
  logical file end done:
    close(file)
OD;

FORMAT plural = $b(" ", "s")$,
       p = $b("", "s")$;

upb list := UPB in files;
printf(($l"File"f(plural)"    = "$, upb list = 1, list repr, in files, $l$,
        $"Total    = "g(-0, 3)l$, tot file,
        $"Readings = "g(-0)l$, num file,
        $"Average  = "g(-0, 3)l$, tot file / num file));

upb list := UPB no data max line;
printf(($l"Maximum run"f(p)" of "g(-0)" consecutive false reading"f(p)" ends at line starting with date"f(p)": "$,
    upb list = 1, no data max, no data max = 0, upb list = 1, list repr, no data max line, $l$))
