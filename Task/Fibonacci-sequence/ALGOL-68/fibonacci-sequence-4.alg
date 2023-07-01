MODE YIELDINT = PROC(INT)VOID;

PROC gen fibonacci = (INT n, YIELDINT yield)VOID: (
  INT even:=0, odd:=1;
  yield(even);
  yield(odd);
  FOR i FROM odd+1 TO n DO
    yield( (ODD i|odd|even) := odd + even )
  OD
);

main:(
  # FOR INT n IN # gen fibonacci(30, # ) DO ( #
  ##   (INT n)VOID:(
        print((" ",whole(n,0)))
  # OD # ));
    print(new line)
)
