##
var q := |1, 1|.ToList;
for var n := 2 to 100_000 do
  q.add(q[n - q[n - 1]] + q[n - q[n - 2]]);

q.take(10).println;
assert(q.Take(10).SequenceEqual(|1, 1, 2, 3, 3, 4, 5, 5, 6, 6|));

q[999].println;
assert(q[999] = 502);

var lessCount := 0;
for var n := 1 to 100_000 do
  if q[n] < q[n - 1] then
    lessCount += 1;
lessCount.Println;
