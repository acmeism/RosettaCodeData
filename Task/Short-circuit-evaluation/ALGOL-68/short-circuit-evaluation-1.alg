PRIO ORELSE = 2, ANDTHEN = 3; # user defined operators #
OP ORELSE =  (BOOL a, PROC BOOL b)BOOL: ( a | a | b ),
   ANDTHEN = (BOOL a, PROC BOOL b)BOOL: ( a | b | a );

# user defined Short-circuit_evaluation procedures #
PROC or else =  (BOOL a, PROC BOOL b)BOOL: ( a | a | b ),
     and then = (BOOL a, PROC BOOL b)BOOL: ( a | b | a );

test:(

  PROC a = (BOOL a)BOOL: ( print(("a=",a,", ")); a),
       b = (BOOL b)BOOL: ( print(("b=",b,", ")); b);

CO
# Valid for Algol 68 Rev0: using "user defined" operators #
# Note: here BOOL is being automatically "procedured" to PROC BOOL #
  print(("T ORELSE F = ", a(TRUE) ORELSE b(FALSE), new line));
  print(("F ANDTHEN T = ", a(FALSE) ANDTHEN b(TRUE), new line));

  print(("or else(T, F) = ", or else(a(TRUE), b(FALSE)), new line));
  print(("and then(F, T) = ", and then(a(FALSE), b(TRUE)), new line));
END CO

# Valid for Algol68 Rev1: using "user defined" operators #
# Note: BOOL must be manually "procedured" to PROC BOOL #
  print(("T ORELSE F = ",  a(TRUE) ORELSE  (BOOL:b(FALSE)), new line));
  print(("T ORELSE T = ",  a(TRUE) ORELSE  (BOOL:b(TRUE)), new line));

  print(("F ANDTHEN F = ", a(FALSE) ANDTHEN (BOOL:b(FALSE)), new line));
  print(("F ANDTHEN T = ", a(FALSE) ANDTHEN (BOOL:b(TRUE)), new line));

  print(("F ORELSE F = ",  a(FALSE) ORELSE  (BOOL:b(FALSE)), new line));
  print(("F ORELSE T = ",  a(FALSE) ORELSE  (BOOL:b(TRUE)), new line));

  print(("T ANDTHEN F = ", a(TRUE) ANDTHEN (BOOL:b(FALSE)), new line));
  print(("T ANDTHEN T = ", a(TRUE) ANDTHEN (BOOL:b(TRUE)), new line))

)
