begin
  var Keys := Arr('aa','bb','cc');
  var Values := Arr(1..3);
  var dct := Dict(Keys.Zip(Values));
  dct.Println;
end.
