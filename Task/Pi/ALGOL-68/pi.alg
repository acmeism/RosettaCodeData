#!/usr/local/bin/a68g --script #

INT base := 10;

MODE YIELDINT = PROC(INT)VOID;
PROC gen pi digits = (INT decimal places, YIELDINT yield)VOID:
BEGIN
  INT nine = base - 1;
  INT nines := 0, predigit := 0; # First predigit is a 0 #
  [decimal places*10 OVER 3]#LONG# INT digits; # We need 3 times the digits to calculate #
  FOR place FROM LWB digits TO UPB digits DO digits[place] := 2 OD; # Start with 2s #
  FOR place TO decimal places + 1 DO
    INT digit := 0;
    FOR i FROM UPB digits BY -1 TO LWB digits DO # Work backwards #
        INT x := #SHORTEN#(base*digits[i] + #LENG# digit*i);
        digits[i] := x MOD (2*i-1);
        digit := x OVER (2*i-1)
    OD;
    digits[LWB digits] := digit MOD base; digit OVERAB base;
    nines :=
      IF digit = nine THEN
        nines + 1
      ELSE
        IF digit = base THEN
          yield(predigit+1); predigit := 0 ;
          FOR repeats TO nines DO yield(0) OD # zeros #
        ELSE
          IF place NE 1 THEN yield(predigit) FI; predigit := digit;
          FOR repeats TO nines DO yield(nine) OD
        FI;
        0
      FI
  OD;
  yield(predigit)
END;

main:(
  INT feynman point = 762; # feynman point + 4 is a good test case #
# the 33rd decimal place is a shorter tricky test case #
  INT test decimal places = UPB "3.1415926.......................502"-2;

  INT width = ENTIER log(base*(1+small real*10));

# iterate throught the digits as they are being found #
# FOR INT digit IN # gen pi digits(test decimal places#) DO ( #,
  ## (INT digit)VOID: (
    printf(($n(width)d$,digit))
  )
# OD #);
  print(new line)
)
