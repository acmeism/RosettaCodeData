################################################
#  Define the basic operators and routines for #
#  manipulating DIGITS specific to a BCD base  #
################################################

####################################################
# BCD noramlly means Binary Coded Decimal, but...  #
# this code handles "Balanced Coded Data", meaning #
# Data can be in any numerical bases, and the data #
# can optionally be stored as Balanced about zero  #
####################################################

# define the basic axioms of the number system you are extending #
MODE DIGIT = STRUCT(#LONG# INT digit);
# Note: If the +:= and *:= operators for INT are being "overloaded",
        then it is sometimes necessary to wrap an INT in a STRUCT to
        protect the builtin definitions of the INT OPerators
#

# mixin the Big_float base definitions #
PR READ "Template.Big_float.Base.a68" PR

MODE BIGREAL  = DIGITS;

# the Yoneda ambiguity forces the peculiar coercion n the body of OP #
OP ZERO = (DIGIT skip)DIGIT: (DIGIT out; digit OF out := 0; out);
OP IDENTITY = (DIGIT skip)DIGIT: (DIGIT out; digit OF out := 1; out);

# define the basis operators #
OP ABS = (DIGIT a)INT: ABS digit OF a;
OP - = (DIGIT a)DIGIT: INITDIGIT -digit OF a;

####################################################################
# Important: Operator +:= is required by Template_Big_float_addition. #
####################################################################
# Note: +:= returns carry DIGIT #
OP +:= = (REF DIGIT lhs, DIGIT arg)DIGIT: (
# Todo: Implement balanced arithmetic #
  INT sum = digit OF lhs + digit OF arg;   # arg may be -ve #
  INT carry := sum % base OF arithmetic;
  INT digit := sum - carry * base OF arithmetic;
  IF balanced OF arithmetic THEN
     INT half base = base OF arithmetic OVER 2;
     IF   digit > half base THEN
       digit -:= base OF arithmetic;
       carry +:= 1
     ELIF digit < -half base THEN
       digit +:= base OF arithmetic;
       carry -:= 1
     FI
  FI;
  lhs := INITDIGIT digit; INITDIGIT carry
);

INT half = base OF arithmetic OVER 2;
# ASSERT NOT balanced OF arithmetic OR ODD base OF arithmetic #
##########################################################################
# Important: Operator *:= is required by Template_Big_float_multiplication. #
##########################################################################
# Note: *:= returns carry DIGIT #

OP *:= = (REF DIGIT lhs, DIGIT arg)DIGIT: (
# Todo: Implement balanced arithmetic #
  INT product = digit OF lhs * digit OF arg;   # arg may be -ve #
  INT carry = product % base OF arithmetic;
  lhs := INITDIGIT(product - carry * base OF arithmetic);
  INITDIGIT carry
);

##########################################################
# Define the basic coersion/casting rules between types. #
##########################################################
OP INITLONGREAL = (BIGREAL a)LONG REAL:
  IF SIGN a = 0 THEN 0
  ELSE
    INT lsd a = LSD a; # Todo: Optimise/reduce to match "long real width" #
    LONG REAL out := digit OF a[MSD a];
    FOR place FROM MSD a - digit order OF arithmetic BY -digit order OF arithmetic TO lsd a DO
      out := out * base OF arithmetic + digit OF a[place]
    OD;
    out * LONG REAL(base OF arithmetic) ** -LSD a
  FI;

OP INITREAL = (BIGREAL r)REAL:
  SHORTEN INITLONGREAL r;

OP MSD = (LONG INT i)INT: (
  LONG INT remainder := i; INT count := 0;
  WHILE remainder /= 0 DO
    remainder %:= base OF arithmetic;
    MOID(count +:= 1)
  OD;
  count
);

OP INITBIGREAL = (LONG INT in int)BIGREAL: (

  INT max = MSD in int;
  [1-max:0]DIGIT out;

  LONG INT int := ABS in int;
  INT sign = SIGN in int;

  FOR place FROM UPB out BY digit order OF arithmetic TO LWB out WHILE int /= 0 DO
    INT digit := SHORTEN (int MOD base OF arithmetic);
    int := (int-digit) OVER base OF arithmetic;
    (digit OF out)[place] := sign * digit
  OD;
done:
  INITDIGITS out # normalise #
);

OP INITBIGREAL = (INT in int)BIGREAL:
  INITBIGREAL LENG in int;

OP INITBIGREAL = (LONG REAL in real)BIGREAL: (

  INT sign = SIGN in real;
  LONG REAL real := ABS in real;
  LONG REAL frac := real - ENTIER real;
  BIGREAL whole = INITBIGREAL ENTIER real; # normalised #

  INT base = base OF arithmetic,
      order = digit order OF arithmetic,
      lsd = digit places OF arithmetic; # Todo: can be optimised/reduced #

  [MSD whole:lsd]DIGIT out; out[MSD whole:LSD whole] := whole[@1];
  FOR place FROM LSD whole - order TO 0 DO out[place] := INITDIGIT 0 OD; # pad #

  FOR place FROM -order BY -order TO lsd DO
    frac *:= base;
    #LONG# INT digit := SHORTEN ENTIER frac;
    frac -:= digit;
    (digit OF out)[place] := digit;
    IF frac = 0 THEN done FI
  OD;
done:
  IF sign > 1 THEN INITDIGITS out ELSE - INITDIGITS out FI
);

OP INITBIGREAL = (REAL in real)BIGREAL:
  INITBIGREAL LENG in real;

#FORMAT digit fmt = $n(digit width OF arithmetic+ABS balanced OF arithmetic)(d)$;#
FORMAT big real fmt = $g((digit width OF arithmetic+ABS balanced OF arithmetic))","$;

OP REPR = (DIGIT digit)STRING:
  IF LWB repr OF arithmetic <= digit OF digit AND digit OF digit <= UPB repr OF arithmetic THEN
    (repr OF arithmetic)[digit OF digit]
  ELIF balanced OF arithmetic THEN
    whole(digit OF digit,digit width OF arithmetic+1)
  ELSE
    whole(digit OF digit,-digit width OF arithmetic)
  FI;

OP REPR = (BIGREAL real)STRING:(
  CHAR repr 0 = "0";
  STRING out;
  FOR place FROM MSD real BY -digit order OF arithmetic TO LSD real DO
    IF place = 1 AND place =  MSD real THEN out +:= "." FI;
    out +:= REPR(real[place]);
    IF place = 0 AND place /=  LSD real THEN out +:= "." FI
  OD;
  IF out = "" THEN out := repr 0 FI;
  IF SIGN real < 0 AND NOT balanced OF arithmetic THEN "-" +=: out FI;
  IF MSD real > 1 AND LSD real > 1 OR
     MSD real < 0 AND LSD real < 0 THEN
  # No decimal point yet, so maybe we need to add an exponent #
    out+IF digit order OF arithmetic*LSD real = 1 THEN repr 0
        ELSE "e"+REPR INITBIGREAL(digit order OF arithmetic*LSD real) FI
        # ELSE "E"+whole(digit order OF arithmetic*LSD real,0) FI #
  ELSE
    out
  FI
);
