program sqfreeints(output);
  (* Square-free integers *)
var
  i, c: integer;

  (* Return true if n has no square divisors other than 1 *)
  function sqfree(n: integer): boolean;
  var
    i, sq: integer;
    sqf: boolean;
  begin
    (* quick exit for most common square *)
    sqf := (n mod 4 <> 0);
    i := 3;
    sq := i * i;
    while (sq <= n) and sqf do
      if n mod sq = 0 then
        sqf := false
      else
      begin
        i := i + 2;
        sq := i * i;
      end;
    sqfree := sqf;
  end;

  (* Report number of square-free integers up to limit *)
  procedure report(limit: integer);
  var
    i, c: integer;
  begin
    write('Square-free integers up to ', limit: 6, ': ');
    c := 0;
    for i := 1 to limit do
      if sqfree(i) then
        c := c + 1;
    writeln(c: 5, ' were found.');
  end;

begin
  c := 0;
  writeln('Square free integers up to 145:');
  for i := 1 to 145 do
    if sqfree(i) then
    begin
      write(i: 4);
      c := c + 1;
      if c mod 10 = 0 then
        writeln;
    end;
  writeln(c: 1, ' were found.');
  writeln;
  report(100);
  report(1000);
  report(10000);
  report(100000);
  (* readln; *)
end.
