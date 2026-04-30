program josephus(output);

  (* Josephus problem *)
var
  n, k, m: integer;

  function josephus(n, k, m: integer): integer;
  var
    a, j: integer;
  begin
    j := m;
    for a := m + 1 to n do
      j := (j + k) mod a;
    josephus := j;
  end;

begin
  n := 41;
  k := 3;
  m := 0;
  writeln('N = ', n:1, ', K = ', k:1, ', Final survivor = ', josephus(n, k, m):1);
  (* readln; *)
end.
