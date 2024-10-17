program GenericSwap;

type
  TSwap = class
    class procedure Swap<T>(var left, right: T);
  end;

class procedure TSwap.Swap<T>(var left, right: T);
var
  temp : T;
begin
  temp := left;
  left := right;
  right := temp;
end;

var
  a, b : integer;

begin
  a := 5;
  b := 3;
  writeln('Before swap: a=', a, ' b=', b);
  TSwap.Swap<integer>(a, b);
  writeln('After swap: a=', a, ' b=', b);
end.
