function ffs: sequence of integer; forward;

function ffr: sequence of integer;
begin
  var n := 1;
  yield n;
  foreach var s in ffs do
  begin
    n += s;
    yield n;
  end;
end;

function ffs: sequence of integer;
begin
  yield 2;
  yield 4;
  var u := 5;
  foreach var r in ffr do
  begin
    if r <= u then continue;
    foreach var x in (u..r - 1) do yield x;
    u := r + 1;
  end;
end;

begin
  ffr.Take(10).Println;
  var a := ffr.Take(40) + ffs.Take(960);
  (1..1000).SequenceEqual(a.Sorted).Println;
end.
