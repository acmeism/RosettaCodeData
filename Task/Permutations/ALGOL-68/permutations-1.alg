# Document prelude template usage:
TEMPLATE(
  INT upb values := 4;
  MODE VALUE = INT;
  FORMAT value fmt := $g(0)$
); #

MODE
  VALVALUES = [upb values]VALUE, VALUES = REF VALVALUES,
  YIELDVALUES = PROC(VALUES)VOID;

FORMAT
  values fmt := $"("n(upb values-1)(f(value fmt)", ")f(value fmt)")"$;

# Generate permutations of the input values of valueues #
PROC gen values permutations = (VALUES values, YIELDVALUES yield)VOID: (
# Warning: this routine does not correctly handle duplicate elements #
  IF LWB values = UPB values THEN
    yield(values)
  ELSE
    FOR elem FROM LWB values TO UPB values DO
      VALUE first = values[elem];
      values[LWB values+1:elem] := values[:elem-1];
      values[LWB values] := first;
    # FOR VALUES next values IN # gen values permutations(values[LWB values+1:] # ) DO #,
    ##   (VALUES next)VOID:(
        yield(values)
    # OD #));
      values[:elem-1] := values[LWB values+1:elem];
      values[elem] := first
    OD
  FI
);

############################################
# Define some additional utility OPerators #
############################################
PRIO P = 7; # OP to calculate number of permutations #
OP P = (INT n, k)INT: ( # n! OVER (n-k)! #
  # ( n>k | n * ((n-1) P k) | n ); #
  INT out := k;
  FOR i FROM k+1 TO n DO out *:= i OD;
  out
);

# Define an operator for doing iterations over permutations #
PRIO DOPERM = 1;
OP (VALUES, YIELDVALUES)VOID DOPERM = gen values permutations;

# Return an a matrix of permutations #
OP PERM = (VALUES in values)[, ]VALUE: (
  [(UPB in values-LWB in values+1) P 1, LWB in values:UPB in values]VALUE out;
  INT elem := LWB out;

# FOR VALUES values IN # in values DOPERM (
##   (VALUES values)VOID:(
    out[elem, ] := values;
    elem +:= 1
# OD #));
  out
);
