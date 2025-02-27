##
function maprange(a, b: (real, real); s: real) := b[0] + (s - a[0]) * (b[1] - b[0]) / (a[1] - a[0]);

for var i := 0 to 10 do
  Writeln(i, ' maps to ', maprange((0, 10), (-1, 0), i));
