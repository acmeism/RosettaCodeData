program bellnums(output);
  (* Bell numbers *)
const
  maxn = 14; (* with 32-bit integer *)
var
  a: array[0..maxn - 1] of integer;
  i, j, n: integer;
begin
  n := 0;
  for i := 0 to maxn - 1 do a[i] := 0;
  a[0] := 1;
  writeln('B(', n: 2, ') = ', a[0]: 9);
  while n < maxn do
  begin
    a[n] := a[0];
    for j := n downto 1 do a[j - 1] := a[j - 1] + a[j];
    n := n + 1;
    writeln('B(', n: 2, ') = ', a[0]: 9);
  end;
end.
