Procedure ShellSort(var buf:Array of Integer);
const
  gaps:array[0..7] of Integer = (701, 301, 132, 57, 23, 10, 4, 1);

var
  whichGap, i, j, n, gap, temp : Integer;

begin
  n := high(buf);
  for whichGap := 0 to high(gaps) do begin
    gap := gaps[whichGap];
    for i := gap to n do begin
      temp := buf[i];

      j := i;
      while ( (j >= gap ) and ( (buf[j-gap] > dt) ) do begin
        buf[j] := buf[j-gap];
        dec(j, gap);
      end;
      buf[j] := temp;
    end;
  end;
end;
