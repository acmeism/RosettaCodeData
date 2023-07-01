Program zigzag;
{$APPTYPE CONSOLE}

const
  size = 5;

  var
  s: array [1..size, 1..size] of integer;
  i, j, d, max, n: integer;

begin
    i := 1;
    j := 1;
    d := -1;
    max := 0;
    n := 0;
    max := size * size;

  for n := 1 to (max div 2)+1 do begin
      s[i,j] := n;
      s[size - i + 1,size - j + 1] := max - n + 1;
      i:=i+d;
      j:=j-d;
      if i < 1 then begin
        inc(i);
        d := -d;
        end else if j < 1 then begin
        inc(j);
        d := -d;
      end;
    end;

  for j := 1 to size do
  begin
    for i := 1 to size do
      write(s[i,j]:4);
    writeln;
  end;

end.
