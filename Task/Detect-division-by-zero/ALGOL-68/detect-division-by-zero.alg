PROC raise exception= ([]STRING args)VOID: (
  put(stand error, ("Exception: ",args, newline));
  stop
);

PROC raise zero division error := VOID:
  raise exception("integer division or modulo by zero");

PROC int div  = (INT a,b)REAL: a/b;
PROC int over = (INT a,b)INT:  a%b;
PROC int mod  = (INT a,b)INT: a%*b;

BEGIN
  OP /  = (INT a,b)REAL: ( b = 0 | raise zero division error; SKIP | int div (a,b) );
  OP %  = (INT a,b)INT:  ( b = 0 | raise zero division error; SKIP | int over(a,b) );
  OP %* = (INT a,b)INT:  ( b = 0 | raise zero division error; SKIP | int mod (a,b) );

  PROC a different handler = VOID: (
      put(stand error,("caught division by zero",new line));
      stop
  );

  INT x:=1, y:=0;
  raise zero division error := a different handler;
  print(x/y)
END
