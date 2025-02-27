function genSequence(ones: list<string>; numZeros: integer): list<string>;
begin
  result := new list<string>;
  if ones.Count = 0 then result := Lst('0' * (numZeros +1))
  else
    foreach var x in 1..(numZeros - ones.Count + 2) do
    begin
      var skipOne := ones.Skip(1).ToList;
      foreach var tail in genSequence(skipOne, numZeros - x) do
        result.add(('0' * x) + ones[0] + tail);
    end;
end;

procedure printBlock(data: string; length: integer);
begin
  var a := data.select(c -> ord(c) - ord('0')).ToList;
  var sumBytes := a.sum;

  writeln(#10, 'blocks ', a, ' cells ', length);
  if length - sumBytes <= 0 then
    println('No solution')
  else
  begin
    var prep := a.Select(n -> '1' * n).ToList;

    foreach var r in genSequence(prep, length - sumBytes) do
      r[2:].println;
  end;
end;

begin
  printBlock('21', 5);
  printBlock('', 5);
  printBlock('8', 10);
  printBlock('2323', 15);
  printBlock('23', 5);
end.
