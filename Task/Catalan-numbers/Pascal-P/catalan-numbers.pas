program catalan(output);
  (* Catalan numbers *)
const
  maxn = 14; (* with 32-bit integer; 10 for 16-bit integer *)
var
  n, c, i: integer;
begin
  n := 0;
  c := 1;
  writeln('C(', n: 2, ') = ', c: 8);
  while n < maxn do
  begin
    n := n + 1;
    i := 0;
    while c > 0 do
    begin
      c := c - (n + 1);
      i := i + 1;
    end;
    c := 2 * (2 * n - 1) * c div (n + 1);
    c := c + 2 * i * (2 * n - 1);
    writeln('C(', n: 2, ') = ', c: 8);
  end;
  (* readln; *)
end.
