uses school;

function hero(a, b, c: integer): real;
begin
  var s := (a + b + c) / 2;
  var a2 := s * (s - a) * (s - b) * (s - c);
  result := if a2 > 0 then a2.sqrt else 0;
end;

function is_heronian(a, b, c: integer):  boolean;
begin
  var h := hero(a, b, c);
  result := (h > 0) and (h = h.Ceil);
end;

function gcd3(x, y, z: integer) := gcd(gcd(x, y), z);

function heronians(n: integer): sequence of (integer, integer, integer);
begin
  for var x := 1 to n do
    for var y := x to n do
      for var z := y to n do
        if (x + y > z) and (gcd3(x, y, z) = 1) and is_heronian(x, y, z) then
          yield (x, y, z);
end;

begin
  var n := 200;
  var hsorted := heronians(n).OrderBy(t -> hero(t[0], t[1], t[2]))
                             .ThenBy(t -> t[0] + t[1] + t[2])
                             .ThenBy(t -> t[2]);

  writeln('Primitive Heronian triangles with sides up to ', n, ': ', hsorted.count);
  writeln;
  writeln('First ten when ordered by increasing area, then perimeter, then maximum sides:');
  foreach var h in hsorted.Take(10) do
    writeln(h:12, ' perim: ', h[0] + h[1] + h[2]:3, ' area: ', hero(h[0], h[1], h[2]):3);
  writeln;
  writeln('All with area 210 subject to the previous ordering:');
  foreach var h in hsorted.Where(t -> hero(t[0], t[1], t[2]) = 210) do
    writeln(h:12, ' perim: ', h[0] + h[1] + h[2]:3, ' area: ', hero(h[0], h[1], h[2]):3);
end.
