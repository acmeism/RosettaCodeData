# init pangram: #
INT la = ABS "a", lz = ABS "z";
INT ua = ABS "A", uz = ABS "Z";
IF lz-la+1 > bits width THEN
  put(stand error, "Exception: insufficient bits in word for task");
  stop
FI;

PROC is a pangram = (STRING test)BOOL: (
  BITS a2z := BIN(ABS(2r1 SHL (lz-la))-1); # assume: ASCII & Binary #
  FOR i TO UPB test WHILE
    INT c = ABS test[i];
    IF la <= c AND c <= lz THEN
      a2z := a2z AND NOT(2r1 SHL (c-la))
    ELIF ua <= c AND c <= uz THEN
      a2z := a2z AND NOT(2r1 SHL (c-ua))
    FI;
# WHILE # a2z /= 2r0 DO
    SKIP
  OD;
  a2z = 2r0
);

main:(
  []STRING test list = (
    "Big fjiords vex quick waltz nymph",
    "The quick brown fox jumps over a lazy dog",
    "A quick brown fox jumps over a lazy dog"
  );
  FOR key TO UPB test list DO
    STRING test = test list[key];
    IF is a pangram(test) THEN
      print(("""",test,""" is a pangram!", new line))
    FI
  OD
)
