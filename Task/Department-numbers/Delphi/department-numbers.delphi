program Department_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  i, j, k, count: Integer;

begin
  writeln('Police  Sanitation  Fire');
  writeln('------  ----------  ----');
  count := 0;
  i := 2;
  while i < 7 do
  begin
    for j := 1 to 7 do
    begin
      if j = i then
        Continue;
      for k := 1 to 7 do
      begin
        if (k = i) or (k = j) then
          Continue;
        if i + j + k <> 12 then
          Continue;
        writeln(format('  %d         %d         %d', [i, j, k]));
        inc(count);
      end;
    end;
    inc(i, 2);
  end;
  writeln(#10, count, ' valid combinations');
  readln;
end.
