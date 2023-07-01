function factorial(n: integer): integer;
 var
  i, result: integer;
 begin
  result := 1;
  for i := 2 to n do
   result := result * i;
  factorial := result
 end;
