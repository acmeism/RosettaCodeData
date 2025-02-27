type
  Direction = (up, right, down, left);
  Color = (white, black);

const
  width = 75;
  height = 52;
  maxSteps = 12_000;

begin
  var m: array [1..height] of array [1..width] of color;
  var dir := up;
  var x := width div 2;
  var y := height div 2;

  var i := 0;
  while (i < maxSteps) and (x in (1..width )) and (y in (1..height )) do
  begin
    var turn := m[y][x] = black;
    m[y][x] := if m[y][x] = black then white else black;

    dir := Direction((4 + integer(dir) + (if turn then 1 else -1)) mod 4);
    case dir of
      up:    dec(y);
      right: dec(x);
      down:  inc(y);
      left:  inc(x);
    end;

    inc(i);
  end;

  for var row := 1 to height do
    m[row].select(x -> (if x = white then '.' else '#')).println;
end.
