def fib(n):
  def aux: if   . == 0 then 0
           elif . == 1 then 1
           else (. - 1 | aux) + (. - 2 | aux)
           end;
  if n < 0 then error("negative arguments not allowed")
  else n | aux
  end ;
