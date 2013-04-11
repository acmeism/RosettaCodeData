function fib(n: integer): integer;
 var
  f0, f1, f2, k: integer;
 begin
  f0 := 0;
  f1 := 1;
  for k := 2 to n do
   begin
    f2:= f0 + f1;
    f0 := f1;
    f1 := f2;
   end;
  fib := f2;
 end;
