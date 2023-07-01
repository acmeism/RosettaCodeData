STRING numeric alpha = "0123456789abcdefghijklmnopqrstuvwxyz";

PROC raise value error = ([]STRING args)VOID: (
  put(stand error, "Value error");
  STRING sep := ": ";
  FOR index TO UPB args - 1 DO put(stand error, (sep, args[index])); sep:=", " OD;
  new line(stand error);
  stop
);

PROC base n = (INT num, base)STRING: (
  PROC base n = (INT num, base)STRING:
    ( num = 0 | "" |  base n(num OVER base, base) + numeric alpha[@0][num MOD base]);
  ( num = 0 | "0" |: num > 0 | base n(num, base) | "-" + base n(-num, base) )
);

PROC unsigned int = (STRING repr, INT base)INT:
  IF UPB repr < LWB repr THEN 0 ELSE
    INT pos;
    IF NOT char in string(repr[UPB repr], pos, numeric alpha) THEN
      raise value error("CHAR """+repr[UPB repr]+""" not valid")
    FI;
    unsigned int(repr[:UPB repr-1], base) * base + pos - 1
  FI
;

PROC int = (STRING repr, INT base)INT:
  ( repr[LWB repr]="-" | -unsigned int(repr[LWB repr + 1:], base) | unsigned int(repr, base) );

[]INT test = (-256, -255, -26, -25, 0, 25, 26, 255, 256);
FOR index TO UPB test DO
  INT k = test[index];
  STRING s = base n(k,16); # returns the string 1a #
  INT i = int(s,16);  # returns the integer 26 #
  print((k," => ", s, " => ", i, new line))
OD
