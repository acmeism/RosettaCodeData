function permutationTest(a, b: array of integer): real;
begin
  var ab := a + b;
  var Tobs := a.Sum;
  var under := 0;
  var count := 0;
  foreach var perm in ab.Combinations(a.Length) do
  begin
    if perm.Sum <= Tobs then under += 1;
    count += 1;
  end;
  result := under * 100 / count;
end;

begin
  var treatmentGroup := [85, 88, 75, 66, 25, 29, 83, 39, 97];
  var controlGroup := [68, 41, 10, 49, 16, 65, 32, 92, 28, 98];
  var under := permutationTest(treatmentGroup, controlGroup);
  write('under= ', under:2:2, '%, over= ', (100 - under):2:2, '%');
end
