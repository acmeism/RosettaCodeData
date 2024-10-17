begin
  var x, xi, y, yi, z, zi: real;
  x := 2.0;
  xi := 0.5;
  y := 4.0;
  yi := 0.25;
  z := x + y;
  zi := 1.0 / (x + y);

  var numlist := new real[] ( x, y, z );
  var numlisti := new real[] ( xi, yi, zi );
  var multiplied := numlist.Zip(numlisti, (n1, n2) -> begin
    var multiplier: real -> real := m -> n1 * n2 * m;
    Result := multiplier;
  end);

  foreach var multiplier in multiplied do
    Println(multiplier(0.5));
end.
