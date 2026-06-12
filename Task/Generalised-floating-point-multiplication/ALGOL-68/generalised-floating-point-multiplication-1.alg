##########################################
#               TASK CODE                #
# Actual generic mulitplication operator #
##########################################
# Alternatively use http://en.wikipedia.org/wiki/Karatsuba_algorithm #

OP * = (DIGITS a, b)DIGITS: (
  DIGITS minus one = -IDENTITY LOC DIGITS,
         zero = ZERO LOC DIGITS,
         one = IDENTITY LOC DIGITS;
  INT order = digit order OF arithmetic;
  IF SIGN a = 0 OR SIGN b = 0 THEN zero
CO # Note: The following require the inequality operators #
  ELIF a = one THEN b
  ELIF b = one THEN a
  ELIF a = minus one THEN -b
  ELIF b = minus one THEN -a
END CO
  ELSE
    DIGIT zero = ZERO LOC DIGIT;
    DIGIT one =  IDENTITY LOC DIGIT;
    [order + MSD a+MSD b: LSD a+LSD b]DIGIT a x b;

    FOR place FROM LSD a+LSD b BY order TO LSD a+MSD b DO
      a x b[place] := zero # pad the MSDs of the result with Zero #
    OD;
    FOR place a FROM LSD a BY order TO MSD a DO
      DIGIT digit a = a[place a];
      DIGIT carry := zero;
      FOR place b FROM LSD b BY order TO MSD b DO
        DIGIT digit b = b[place b];
        REF DIGIT digit ab = a x b[place a + place b];
        IF carry OF arithmetic THEN # used for big number arithmetic #
          MOID(carry := ( digit ab +:= carry ));
          DIGIT prod := digit a;
          MOID(carry +:= ( prod *:= digit b ));
          MOID(carry +:= ( digit ab +:= prod ))
        ELSE # carry = 0 so we can just ignore the carry #
          DIGIT prod := digit a;
          MOID(prod *:= digit b);
          MOID(digit ab +:= prod)
        FI
      OD;
      a x b[place a + MSD b + order] := carry
    OD;
    INITDIGITS a x b # normalise #
  FI
);

######################################
#  Define the hybrid multiplication  #
# operators for the generalised base #
######################################

OP * = (DIGIT a, DIGITS b)DIGITS: INITDIGITS a * b;
OP * = (DIGITS a, DIGIT b)DIGITS: a * INITDIGITS b;

OP *:= = (REF DIGITS lhs, DIGIT arg)DIGITS: lhs := lhs * INITDIGITS arg;
