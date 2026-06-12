#!/usr/local/bin/a68g --script #

##################################################################
#                        TEST CASE                               #
# A program to test abritary length BCD floating point addition. #
##################################################################

PR READ "prelude/general.a68" PR # [[rc:Template:ALGOL 68/prelude]] #

##################################################################
# READ Template for doing the actual arbitary precsion addition. #
##################################################################
PR READ "Template.Big_float.Addition.a68" PR

# include the basic axioms of the digits being used #
PR READ "Template.Big_float_BCD.Base.a68" PR
PR READ "Template.Big_float.Subtraction.a68" PR

test: (
  BIGREAL pattern = INITBIGREAL 012345679,
  INT pattern width = 9;

  BIGREAL
    sum := INITBIGREAL 0,
    shifted pattern := pattern,
    shifted tiny := INITBIGREAL 1; # typically 0.000.....00001 etc #

  FOR term FROM -8 TO 20 DO

  # First make shifted pattern smaller by shifting right by the pattern width #
    shifted pattern := (shifted pattern)[@term*pattern width+2];
    shifted tiny := (shifted tiny)[@(term+1)*pattern width];

    MOID(sum +:= shifted pattern);

  # Manually multiply by 81 by repeated addition #
    BIGREAL prod := sum + sum + sum;
    MOID(prod +:= prod + prod);
    MOID(prod +:= prod + prod);
    MOID(prod +:= prod + prod);

    BIGREAL total = prod + shifted tiny;

    IF term < -4 THEN
      print(( REPR sum," x 81 gives: ", REPR prod, ", Plus ",REPR shifted tiny," gives: "))
    ELSE
      print((LSD prod - MSD prod + 1," digit test result: "))
    FI;
    printf(($g$, REPR total, $" => "b("Passed","Failed")"!"$, LSD total = MSD total, $l$))
  OD
)
