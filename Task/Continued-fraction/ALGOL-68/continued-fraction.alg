PROC cf = (INT steps, PROC (INT) INT a, PROC (INT) INT b) REAL:
BEGIN
  REAL result;
  result := 0;
  FOR n FROM steps BY -1 TO 1 DO
      result := b(n) / (a(n) + result)
  OD;
  a(0) + result
END;

PROC asqr2 = (INT n) INT: (n = 0 | 1 | 2);
PROC bsqr2 = (INT n) INT: 1;

PROC anap = (INT n) INT: (n = 0 | 2 | n);
PROC bnap = (INT n) INT: (n = 1 | 1 | n - 1);

PROC api = (INT n) INT: (n = 0 | 3 | 6);
PROC bpi = (INT n) INT: (n = 1 | 1 | (2 * n - 1) ** 2);

INT precision = 10000;

print (("Precision: ", precision, newline));
print (("Sqr(2):    ", cf(precision, asqr2, bsqr2), newline));
print (("Napier:    ", cf(precision, anap, bnap), newline));
print (("Pi:        ", cf(precision, api, bpi)))
