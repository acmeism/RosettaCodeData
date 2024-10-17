USES
   Math;

function NthRoot(A, Precision: Double; n: Integer): Double;
var
   x_p, X: Double;
begin
   x_p := Sqrt(A);
   while Abs(A - Power(x_p, n)) > Precision do
   begin
      x := (1/n) * (((n-1) * x_p) + (A/(Power(x_p, n - 1))));
      x_p := x;
   end;
   Result := x_p;
end;
