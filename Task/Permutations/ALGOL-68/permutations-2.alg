#!/usr/local/bin/a68g --script #

PR READ "Template_Permutations.a68" PR # n.b. READ is nonstandard #
# USING( #
  INT upb values := 4;
  MODE VALUE = INT; # user defined #
  FORMAT value fmt := $g(0)$
# ) #;

main:(
  VALVALUES test case := (1, 22, 333, 44444);
  print(("Number of permutations: ", UPB test case P 1, new line));

COMMENT # Use the generator: #
  # FOR ARRAY values IN # test case DOPERM (
  ##   (ARRAY values)VOID:(
      printf((values fmt, values, $l$))
  # OD #));
END COMMENT

# or simply the operator: #
  printf(($f(values fmt)l$, PERM test case))
)
