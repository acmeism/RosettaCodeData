function bsdRand(seed: integer): sequence of integer;
begin
  while true do
  begin
    seed := (1_103_515_245 * seed + 12_345) and $7fffffff;
    yield seed
  end;
end;

function msvcrtRand(seed: integer): sequence of integer;
begin
  while true do
  begin
    seed := (214_013 * seed + 2_531_011) and $7fffffff;
    yield seed shr 16
  end;
end;

begin
  'BSD with seed = 1'.println;
  var iter1 := bsdRand(1);
  foreach var val in iter1.Take(10) do
    println(val);
  println;
  'Microsoft with seed = 0'.Println;
  var iter2 := msvcrtRand(0);
  foreach var val in iter2.Take(10) do
    println(val);
end.
