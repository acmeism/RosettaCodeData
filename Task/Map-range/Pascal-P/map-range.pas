program map(output);
(* Map range *)
var
  i: integer;

  function maprange(a1, a2, b1, b2: real; s: real): real;
  begin
    maprange := (s - a1) * (b2 - b1) / (a2 - a1) + b1;
  end;

begin
  for i := 0 to 10 do
    writeln(i: 2, ' maps to: ', maprange(0.0, 10.0, -1.0, 0.0, i): 10);
end.
