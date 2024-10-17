uses school;

function is_duffinian(x: integer) :=
    (gcd(x, divisors(x).Sum) = 1) and
    (divisors(x).ToArray.Length > 2);

begin
  var count := 0;
  var i := 0;
  writeln('First 50 Duffinian numbers:');
  while count < 50 do
  begin
    if is_duffinian(i) then
    begin
      write(i:4);
      count += 1;
      if count mod 10 = 0 then writeln;
    end;
    i += 1
  end;

  count := 0;
  i := 0;
  writeln;
  writeln('First 15 Duffinian triplets:');
  while count < 15 do
  begin
    if is_duffinian(i) and is_duffinian(i + 1) and is_duffinian(i + 2) then
    begin
      writeln(i:6, i + 1:6, i + 2:6);
      count += 1;
      i += 3;
    end;
    i += 1;
  end;
end.
