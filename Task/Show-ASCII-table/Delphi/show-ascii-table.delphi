program Show_Ascii_table;

{$APPTYPE CONSOLE}

var
  i, j: Integer;
  k: string;

begin
  for i := 0 to 15 do
  begin
    j := 32 + i;
    while j < 128 do
    begin
      case j of
        32:
          k := 'Spc';
        127:
          k := 'Del';
      else
        k := chr(j);
      end;
      Write(j: 3, ' : ', k: 3, '   ');
      inc(j, 16);
    end;
    Writeln;
  end;
  Readln;
end.
