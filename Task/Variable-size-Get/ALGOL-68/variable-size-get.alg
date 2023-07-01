INT i; BYTES b; # typically INT and BYTES are the same size #
STRING s:="DCLXVI", [666]CHAR c;
print((
  "sizeof INT i =",bytes width, new line,
  "UPB STRING s =",UPB s, new line,
  "UPB []CHAR c =",UPB c, new line
))
