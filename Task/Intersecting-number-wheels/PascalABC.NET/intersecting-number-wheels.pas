function WheelCreator(wheel: string): () -> char;
begin
  var index := 1;

  result := function(): char ->
  begin
    result := wheel[index];
    index := if index >= wheel.Length then 1 else index + 1;
  end;
end;

function TurnWheels(primary: char; wheels: dictionary<char, () -> char>): sequence of char;
begin
  while true do
  begin
    var turn := wheels.Get(primary)();
    while not turn.IsDigit do
      turn := wheels.Get(turn);
    yield turn;
  end;
end;

begin
  var allwheels :=
  ||('A', '123')|,
  |('A', '1B2'), ('B', '34')|,
  |('A', '1DD'), ('D', '678')|,
  |('A', '1BC'), ('B', '34'), ('C', '5B')||;

  foreach var wheels in allwheels do
  begin
    foreach var w in wheels do
      writeln(w[0], ': ', w[1]);
    println('Generates:');
    var t := TurnWheels(wheels[0][0], wheels.ToDictionary(x -> x[0], x -> WheelCreator(x[1])));
    println(t.Take(20));
    println;
  end;
end.
