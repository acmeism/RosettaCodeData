function fib(n: integer): integer;
 begin
  if (n = 0) or (n = 1)
   then
    fib := n
   else
    fib := fib(n-1) + fib(n-2)
 end;
