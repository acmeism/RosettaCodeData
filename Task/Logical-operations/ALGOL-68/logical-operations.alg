PROC print_logic = (BOOL a, b)VOID:
(
# for a 6-7 bit/byte compiler #
  printf(($"a and b is "gl$, a AND b);
  printf(($"a or b is "gl$, a OR b);
  printf(($"not a is "gl$, NOT a);
  printf(($"a equivalent to b is "gl$, a EQ b);
  printf(($"a not equivalent to b is "gl$, a NE b);

# Alternatively ASCII #
  printf(($"a and b is "gl$, a & b);
  printf(($"a and b is "gl$, a /\ b);  <!-- http://web.archive.org/web/20021207211127/http://www.bobbemer.com/BRACES.HTM -->
  printf(($"a or b is "gl$, a \/ b);
  printf(($"a equivalent to b "gl$, a = b);
  printf(($"a not equivalent to b "gl$, a /= b);

¢ for a European 8 bit/byte charcter set eg. ALCOR or GOST ¢
  printf(($"a and b is "gl$, a ∧ b);
  printf(($"a or b is "gl$, a ∨ b);
  printf(($"not a is "gl$, ¬ a)
  printf(($"a not equivalent to b is "gl$, a ≠ b)
)
