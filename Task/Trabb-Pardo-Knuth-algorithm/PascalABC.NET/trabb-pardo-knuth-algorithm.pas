function f(x:real) := Sqrt(x) + 5 *x ** 3;

begin
  var seq := ReadArrInteger(11).Reverse;
  foreach var x in seq do
  begin
    var fx := f(x);
    Println($'f({x}): {fx > 400 ? ''overflow'' : fx.ToString}');
  end;
end.
