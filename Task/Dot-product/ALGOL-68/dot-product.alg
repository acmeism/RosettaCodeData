MODE DOTFIELD = REAL;
MODE DOTVEC = [1:0]DOTFIELD;

# The "Spread Sheet" way of doing a dot product:
  o Assume bounds are equal, and start at 1
  o Ignore round off error
#
PRIO SSDOT = 7;
OP SSDOT = (DOTVEC a,b)DOTFIELD: (
  DOTFIELD sum := 0;
  FOR i TO UPB a DO sum +:= a[i]*b[i] OD;
  sum
);

# An improved dot-product version:
  o Handles sparse vectors
  o Improves summation by gathering round off error
    with no additional multiplication - or LONG - operations.
#
OP * = (DOTVEC a,b)DOTFIELD: (
  DOTFIELD sum := 0, round off error:= 0;
  FOR i
# Assume bounds may not be equal, empty members are zero (sparse) #
    FROM LWB (LWB a > LWB b | a | b )
    TO UPB (UPB a < UPB b | a | b )
  DO
    DOTFIELD org = sum, prod = a[i]*b[i];
    sum +:= prod;
    round off error +:= sum - org - prod
  OD;
  sum - round off error
);

# Test: #
DOTVEC a=(1,3,-5), b=(4,-2,-1);

print(("a SSDOT b = ",fixed(a SSDOT b,0,real width), new line));
print(("a   *   b = ",fixed(a   *   b,0,real width), new line))
