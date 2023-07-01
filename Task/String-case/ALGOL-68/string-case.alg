#!/usr/local/bin/a68g --script #

# Demonstrate toupper and tolower for standard ALGOL 68
strings.  This does not work for multibyte character sets. #

INT l2u = ABS "A" - ABS "a";

PROC to upper = (CHAR c)CHAR:
  (ABS "a" > ABS c | c |: ABS c > ABS "z" | c | REPR ( ABS c + l2u ));

PROC to lower = (CHAR c)CHAR:
  (ABS "A" > ABS c | c |: ABS c > ABS "Z" | c | REPR ( ABS c - l2u ));

# Operators can be defined in ALGOL 68 #
OP (CHAR)CHAR TOLOWER = to lower, TOUPPER = to upper;

# upper-cases s in place #
PROC string to upper = (REF STRING s)VOID:
    FOR i FROM LWB s TO UPB s DO s[i] := to upper(s[i]) OD;

# lower-cases s in place #
PROC string to lower = (REF STRING s)VOID:
    FOR i FROM LWB s TO UPB s DO s[i] := to lower(s[i]) OD;

main: (
    STRING t := "alphaBETA";
    string to upper(t);
    printf(($"uppercase: "gl$, t));
    string to lower(t);
    printf(($"lowercase: "gl$, t))
)
