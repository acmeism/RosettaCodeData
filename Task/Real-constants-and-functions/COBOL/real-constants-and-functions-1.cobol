E          *> e
PI         *> Pi
SQRT(n)    *> Sqaure root
LOG(n)     *> Natural logarithm
LOG10(n)   *> Logarithm (base 10)
EXP(n)     *> e to the nth power
ABS(n)     *> Absolute value
INTEGER(n) *> While not a proper floor function, it is implemented in the same way.
*> There is no ceiling function. However, it could be implemented like so:
ADD 1 TO N
MOVE INTEGER(N) TO Result
*> There is no pow function, although the COMPUTE verb does have an exponention operator.
COMPUTE Result = N ** 2
