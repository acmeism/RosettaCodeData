PROC iterative fibonacci = (INT n)INT:
  CASE n+1 IN
    0, 1, 1, 2, 3, 5
  OUT
    INT even:=3, odd:=5;
    FOR i FROM odd+1 TO n DO
      (ODD i|odd|even) := odd + even
    OD;
    (ODD n|odd|even)
  ESAC;

FOR i FROM 0 TO 30 WHILE
  print(whole(iterative fibonacci(i),0));
# WHILE # i /= 30 DO
  print(", ")
OD;
print(new line)
