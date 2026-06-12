OP - = (DIGITS arg)DIGITS: (
  DIGITS out := arg;
  FOR digit FROM LSD arg BY digit order OF arithmetic TO MSD arg DO
    out[digit]:= -out[digit]
  OD;
  out
);

OP SIGN = (DIGITS arg)INT:
  IF LSD arg - MSD arg  = digit order OF arithmetic THEN 0 # empty array #
  ELSE # balanced artihmetic # SIGN arg[MSD arg] FI;

OP ABS = (DIGITS arg)DIGITS:
  IF SIGN arg < 0 THEN -arg ELSE arg FI;

# derived DIGIT operators #
OP - = (DIGIT a, b)DIGIT: a + -b;
OP -:= = (REF DIGIT a, DIGIT b)DIGIT: a := a + -b;

# derived DIGITS operators #
OP - = (DIGITS a, b)DIGITS: a + -b;
OP -:= = (REF DIGITS a, DIGITS b)DIGITS: a := a + -b;

# derived hybrid DIGIT and DIGITS operators #
OP - = (DIGITS a, DIGIT b)DIGITS: a - INITDIGITS b;
OP - = (DIGIT a, DIGITS b)DIGITS: INITDIGITS a - a;
OP -:= = (REF DIGITS lhs, DIGIT arg)DIGITS: lhs := lhs - arg;
