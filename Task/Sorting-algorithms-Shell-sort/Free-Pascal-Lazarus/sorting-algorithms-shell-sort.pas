procedure ShellSort(var a: array of extended);
var
  i, j, h, n: integer;
  v: extended;
begin
  n := length(a);
  h := 1;
  repeat
    h := 3 * h + 1
  until h > n;
  repeat
    h := h div 3;
    for i := h to n - 1 do
    begin
      v := a[i];
      j := i;
      while (j >= h) and (a[j - h] > v) do
      begin
        a[j] := a[j - h];
        j := j - h;
      end;
      a[j] := v;
    end
  until h = 1;
end;
