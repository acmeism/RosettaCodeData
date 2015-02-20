function fib(n: integer):longInt;
const
  Sqrt5 = sqrt(5.0);
  C1 = ln((Sqrt5+1.0)*0.5);//ln( 1.618..)
//C2 = ln((1.0-Sqrt5)*0.5);//ln(-0.618 )) tsetsetse
  C2 = ln((Sqrt5-1.0)*0.5);//ln(+0.618 ))
begin
  IF n>0 then
  begin
    IF odd(n) then
      fib := round((exp(C1*n) + exp(C2*n) )/Sqrt5)
    else
      fib := round((exp(C1*n) - exp(C2*n) )/Sqrt5)
  end
  else
    Fibdirekt := 0
end;
