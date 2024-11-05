function ThueMorseSequence(terms, baseValue: integer): list<integer>;
begin
  result := new List<integer>;
  for var i := 0 to terms - 1 do
  begin
    var sum := 0;
    var n := i;
    while (n > 0) do
    begin
      // Compute the digit sum
      sum += n mod baseValue;
      n := n div baseValue;
    end;
    // Compute the digit sum modulo baseValue.
    result.Add(sum mod baseValue);
  end;
end;

begin
  foreach var baseValue in |2, 3, 5, 11| do
    println('Base', baseValue, '=', ThueMorseSequence(25, baseValue));
end.
