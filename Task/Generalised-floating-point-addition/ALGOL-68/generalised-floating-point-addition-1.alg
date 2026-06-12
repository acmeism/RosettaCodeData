########################################
#  Define the basic addition operators #
#  for the generalised base            #
########################################

# derived DIGIT operators #
OP + = (DIGIT arg)DIGIT: arg;
OP + = (DIGIT a,b)DIGIT: (DIGIT out := a; MOID(out +:= b); out);

# derived hybrid of DIGIT & DIGITS operators #
OP + = (DIGITS a, DIGIT b)DIGITS: a + INITDIGITS b;
OP + = (DIGIT a, DIGITS b)DIGITS: INITDIGITS a + a;
OP +:= = (REF DIGITS lhs, DIGIT arg)DIGITS: lhs := lhs + arg;

# derived DIGITS operators #
OP + = (DIGITS arg)DIGITS: arg;
OP +:= = (REF DIGITS lhs, DIGITS arg)DIGITS: lhs := lhs + arg;

####################################
#            TASK CODE             #
# Actual generic addition operator #
####################################
OP + = (DIGITS a, b)DIGITS: (
  IF SIGN a = 0 THEN b ELIF SIGN b = 0 THEN a
  ELSE
    MODE SIGNED = DIGIT;

    INT extreme highest = MSD a MIN MSD b,
        overlap highest = MSD a MAX MSD b,
        overlap lowest  = LSD a MIN LSD b,
        extreme lowest  = LSD a MAX LSD b;

    SIGNED zero = ZERO LOC SIGNED;
    INT order = digit order OF arithmetic;
    DIGITS out;

    IF overlap highest > overlap lowest THEN # Either: NO overlapping digits #

      [extreme highest:extreme lowest]SIGNED a plus b;

# First: simply insert the known digits with their correct sign #
      a plus b[MSD a:LSD a] := a[@1];
      a plus b[MSD b:LSD b] := b[@1];

# Next: Zero any totally non overlapping digit #
      FOR place FROM overlap highest+order BY order TO overlap lowest-order
      DO a plus b[place] := zero OD;

# Finally: normalise by removing leading & trailing "zero" digit #
      out := INITDIGITS a plus b

    ELSE # Or: Add ALL overlapping digits #

      [extreme highest+(carry OF arithmetic|order|0):extreme lowest]SIGNED a plus b;

#   First: Deal with the non overlapping Least Significant Digits #
      a plus b[overlap lowest-order:] := (LSD a > LSD b|a|b) [overlap lowest-order:];

#   Or: Add any overlapping digits #
      SIGNED carry := zero;
      FOR place FROM overlap lowest BY order TO overlap highest DO
        SIGNED digit a = a[place], digit b = b[place];
        REF SIGNED result = a plus b[place];
        IF carry OF arithmetic THEN # used in big float #
          result := carry;
          carry := ( result +:= digit a );
          MOID( carry +:= ( result +:= (digit b) ) )
        ELSE
          result  := digit a;
          MOID( result +:= digit b )
        FI
      OD;

#   Next: Deal with the non overlapping Most Significant digits #
      FOR place FROM overlap highest+order BY order TO extreme highest DO
        []DIGIT etc = (MSD a < MSD b|a|b);
        REF SIGNED result = a plus b[place];
        IF carry OF arithmetic THEN
          result := carry;
          carry := ( result +:= etc[place] )
        ELSE
          result := etc[place]
        FI
      OD;

#   Next: Deal with the carry #
      IF carry OF arithmetic THEN
        a plus b[extreme highest+order] := carry
      FI;

#   Finally: normalise by removing leading & trailing "zero" digits #
      out := INITDIGITS a plus b

    FI;
    out # EXIT #
  FI
);
