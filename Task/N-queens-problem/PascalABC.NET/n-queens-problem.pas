const
  N = 8;

begin
  var cols := (1..N);
  var solutions := 0;
  foreach var vec in cols.Permutations do
    if (N = cols.Select(n -> vec[n - 1] + n).ToSet.Count) and
       (N = cols.Select(n -> vec[n - 1] - n).ToSet.Count) then
    begin
      solutions += 1;
//      foreach var col in ('a'..'h') index i do
//        write(col, vec[i], ' ');
//      write(if solutions mod 4 = 0 then #10 else '    ');
    end;
  writeln('Solutions: ', solutions);
end.
