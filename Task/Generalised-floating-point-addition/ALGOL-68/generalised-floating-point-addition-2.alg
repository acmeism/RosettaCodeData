# -*- coding: utf-8 -*- #
################################################
#  Define the basic operators and routines for #
#  manipulating DIGITS in a generalised base   #
################################################

STRUCT (
  BOOL balanced,
       carry, # aka "carry" between digits #
  INT base,
      digit width,
      digit places,
      digit order,
  USTRING repr
) arithmetic := (
  FALSE, TRUE,
  10, 1, 81, -1, # Default is BCD/Hex #
  USTRING( # Note that the "circled" digits are negative - used in balance arithmetic #
           "ⓩ","ⓨ","ⓧ","ⓦ","ⓥ","ⓤ","ⓣ","ⓢ","ⓡ","ⓠ","ⓟ","ⓞ","ⓝ","ⓜ","ⓛ","ⓚ","ⓙ","ⓘ","ⓗ","ⓖ","ⓕ","ⓔ","ⓓ","ⓒ","ⓑ","ⓐ",
           "Ⓩ","Ⓨ","Ⓧ","Ⓦ","Ⓥ","Ⓤ","Ⓣ","Ⓢ","Ⓡ","Ⓠ","Ⓟ","Ⓞ","Ⓝ","Ⓜ","Ⓛ","Ⓚ","Ⓙ","Ⓘ","Ⓗ","Ⓖ","Ⓕ","Ⓔ","Ⓓ","Ⓒ","Ⓑ","Ⓐ",
                   "⑨","⑧","⑦","⑥","⑤","④","③","②","①",    "0",    "1","2","3","4","5","6","7","8","9",
           "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
           "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
  )[@-(26*2+9)] # can print up to base 61, or balanced base 123 #
);

MODE DIGITS = FLEX[0]DIGIT;

# DIGIT OPerators #
OP INITDIGIT = (#LONG# INT i)DIGIT: (DIGIT out; digit OF out := #SHORTEN# i; out);
#OP INITDIGIT = (INT i)DIGIT: INITDIGIT LENG i;#

OP /= = (DIGIT a,b)BOOL: digit OF a /= digit OF b;

# Define additive and multiplicative identities #
OP ZERO = (DIGITS skip)DIGITS: INITDIGITS []DIGIT(ZERO LOC DIGIT),
   IDENTITY = (DIGITS skip)DIGITS: INITDIGITS []DIGIT(IDENTITY LOC DIGIT);

OP SIGN = (DIGIT digit)INT: SIGN digit OF digit;

# Define OPerators for Least and Most Significant DIGIT #
OP MSD = (DIGITS t)INT: LWB t,
   EXP = (DIGITS t)INT: digit order OF arithmetic * LWB t, # exponent #
   LSD = (DIGITS t)INT: UPB t;

OP INITDIGITS = (DIGIT in)DIGITS: INITDIGITS []DIGIT(in)[@0];

OP INITDIGITS = ([]DIGIT digits)DIGITS: (
### normalise digits:
  A) removed leading & trailing zeros
  B) IF not balanced arithmetic
     THEN make all digits positive and set sign bit FI
###
    MODE SIGNED = DIGIT;
    DIGIT zero = ZERO LOC DIGIT;
    DIGIT one = IDENTITY LOC DIGIT;
    DIGIT base digit = INITDIGIT base OF arithmetic;
    INT base = base OF arithmetic;
    INT half base = base % 2;
    INT order = digit order OF arithmetic;

    INT msd := LWB digits + int width*order, lsd := UPB digits; # XXX #

# create an array with some "extra" significant digits incase there is a "big" input value #
    [msd:lsd]SIGNED signed; signed[LWB digits:UPB digits] := digits[@1];
    FOR place FROM LWB signed TO LWB digits+order DO
      signed[place] := zero
    OD;
    IF msd + order /= lsd THEN

#   Trim leading zeros #
      FOR place FROM msd BY -order TO lsd DO
        IF SIGN signed[place] /= 0 THEN msd := place; done msd FI
      OD;
      msd := lsd-order;
    done msd:
#   Trim trailing zeros #
      FOR place FROM lsd BY order TO msd DO
        IF SIGN signed[place] /= 0 THEN lsd := place; done lsd FI
      OD;
      lsd := msd+order;
    done lsd:
      IF msd + order /= lsd THEN  # not zero #
        IF carry OF arithmetic THEN # Normalise to the "base OF arithmetic": #
          INT sign msd := SIGN digits[msd]; # first non zero digit #
          INT lwb digit := (balanced OF arithmetic|-half base|:sign msd < 0 |1-base|0);
          INT upb digit := (balanced OF arithmetic| half base|:sign msd > 0 |base-1|0);
          SIGNED carry := zero;
          FOR place FROM lsd BY order WHILE SIGN carry /=0 OR place >= LWB digits DO
             SIGNED digit := signed[place];
             carry := digit +:= carry;
             WHILE digit OF digit < lwb digit DO
               MOID(digit +:= base digit);
               MOID(carry -:= one)
             OD;
             WHILE digit OF digit > upb digit DO
               MOID(digit -:= base digit);
               MOID(carry +:= one)
             OD;
             signed[place] := digit; # normalised #
             IF SIGN digit /= 0 THEN msd := place FI
          OD
        FI
      FI;
      signed[msd:lsd][@msd]
    FI
  );

# re anchor the array with a shift #
OP SHL = (DIGITS in, INT shl)DIGITS: in[@MSD in-shl];
OP SHR = (DIGITS in, INT shr)DIGITS: in[@MSD in+shr];
