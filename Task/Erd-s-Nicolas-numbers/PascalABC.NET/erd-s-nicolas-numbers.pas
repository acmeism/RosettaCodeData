const
  max_number = 100_000_000;

begin
  var dsum := arrfill(max_number + 1, 1);
  var dcount := arrfill(max_number + 1, 1);
  for var i := 2 to max_number do
    for var j := i + i to max_number step i do
    begin
      if dsum[j] = j then
        writeln(j:8, ' equals the sum of its first ', dcount[j], ' divisors');
      dsum[j] += i;
      dcount[j] += 1;
    end;
end.
