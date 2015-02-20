# -*- coding: utf-8 -*- #
COMMENT PRELUDE REQUIRES
  MODE SCAL = REAL,
  REAL near min scal = min real ** 0.99,
  MODE VEC = []REAL,
  MODE MAT = [,]REAL,
  FORMAT scal repr = real repr,
  and various OPerators of MAT and VEC
END COMMENT

COMMENT PRELUDE PROVIDES
  PROC(MAT a, b)MAT gaussian elimination;
  PROC(REF MAT a, b)REF MAT in situ gaussian elimination
END COMMENT

####################################################
# using Gaussian elimination, find x where A*x = b #
####################################################
PROC in situ gaussian elimination = (REF MAT a, b)REF MAT: (
# Note: a and b are modified "in situ", and b is returned as x #

  FOR diag TO UPB a-1 DO
    INT pivot row := diag; SCAL pivot factor := ABS a[diag,diag];
    FOR row FROM diag + 1 TO UPB a DO # Full pivoting #
      SCAL abs a diag = ABS a[row,diag];
      IF abs a diag>=pivot factor THEN
        pivot row := row; pivot factor := abs a diag FI
    OD;
  # now we have the "best" diag to full pivot, do the actual pivot #
    IF diag NE pivot row THEN
    # a[pivot row,] =:= a[diag,]; XXX: unoptimised # #DB#
      a[pivot row,diag:] =:= a[diag,diag:]; # XXX: optimised #
      b[pivot row,] =:= b[diag,] # swap/pivot the diags of a & b #
    FI;

    IF ABS a[diag,diag] <= near min scal THEN
      raise value error("singular matrix") FI;
    SCAL a diag reciprocal := 1 / a[diag, diag];

    FOR row FROM diag+1 TO UPB a DO
      SCAL factor = a[row,diag] * a diag reciprocal;
    # a[row,] -:= factor * a[diag,] XXX: "unoptimised" # #DB#
      a[row,diag+1:] -:= factor * a[diag,diag+1:];# XXX: "optimised" #
      b[row,] -:= factor * b[diag,]
    OD
  OD;

# We have a triangular matrix, at this point we can traverse backwards
  up the diagonal calculating b\A Converting it initial to a diagonal
  matrix, then to the identity.  #

  FOR diag FROM UPB a BY -1 TO 1+LWB a DO

    IF ABS a[diag,diag] <= near min scal THEN
      raise value error("Zero pivot encountered?") FI;
    SCAL a diag reciprocal = 1 / a[diag,diag];

    FOR row TO diag-1 DO
      SCAL factor = a[row,diag] * a diag reciprocal;
    # a[row,diag] -:= factor * a[diag,diag]; XXX: "unoptimised" so remove # #DB#
      b[row,] -:= factor * b[diag,]
    OD;
# Now we have only diagonal elements we can simply divide b
  by the values along the diagonal of A. #
    b[diag,] *:= a diag reciprocal
  OD;

  b # EXIT #
);

PROC gaussian elimination = (MAT in a, in b)MAT: (
# Note: a and b are cloned and not modified "in situ" #
  [UPB in a, 2 UPB in a]SCAL a := in a;
  [UPB in b, 2 UPB in b]SCAL b := in b;
  in situ gaussian elimination(a,b)
);

SKIP
