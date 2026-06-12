uses PlotWPF;

function inventorySequence(): sequence of integer;
begin
  var counts := new Dictionary<integer, integer>;
  while true do
  begin
    var i := 0;
    while true do
    begin
      var n := counts.Get(i);
      counts[n] := counts.Get(n) + 1;
      yield n;
      if n = 0 then break;
      i += 1;
    end;
  end;
end;

begin
  foreach var element in inventorysequence.Take(100) index i do
    write(element:3, if i mod 20 = 19 then #10 else '');
  println;
  for var n := 1 to 10 do
  begin
    var element := inventorysequence.Select((x, i) -> (i, x)).first(x -> x[1] > n * 1000);
    writeln('First element >= ', n * 1000, ' is ', element[1], ' at index ', element[0]);
  end;

  var x := arrgen(10_000, x -> real(x));
  var y := inventorysequence.Take(10_000).Select(x -> real(x));
  var plot := new MarkerGraphWPF(x, y, Colors.Black, MarkerType.Circle, 3);
end.
