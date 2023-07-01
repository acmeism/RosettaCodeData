MODE NUMBER =  UNION(INT,REAL,COMPL);

PROC plus = (NUMBER in a, in b)NUMBER: (
    CASE in a IN
        (INT a):   CASE in b IN (INT b): a+b, (REAL b): a+b, (COMPL b): a+b ESAC,
        (REAL a):  CASE in b IN (INT b): a+b, (REAL b): a+b, (COMPL b): a+b ESAC,
        (COMPL a): CASE in b IN (INT b): a+b, (REAL b): a+b, (COMPL b): a+b ESAC
    ESAC
);

main: (

# now override the + and +:= OPerators #
  OP + = (NUMBER a, b)NUMBER: plus(a,b);

  OP +:= = (REF NUMBER lhs, NUMBER rhs)NUMBER:
      lhs := lhs + rhs;

  PROC accumulator  = (REF NUMBER sum)PROC(NUMBER)NUMBER:
      (NUMBER n)NUMBER:
          sum +:= n;

  PROC (NUMBER)NUMBER x = accumulator(LOC NUMBER := 1);
  x(5);
  print(("x:",x(2.3), new line));

  PROC (NUMBER)NUMBER y = accumulator(LOC NUMBER := 100);
  y(500);
  print(("y:",y(230), new line));

  print(("x:",x(0), new line))

)
