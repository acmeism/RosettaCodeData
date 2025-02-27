type
  item = (string, integer, integer);

const
  wants: array of item =
  |('map', 9, 150),
  ('compass', 13, 35),
  ('water', 153, 200),
  ('sandwich', 50, 160),
  ('glucose', 15, 60),
  ('tin', 68, 45),
  ('banana', 27, 60),
  ('apple', 39, 40),
  ('cheese', 23, 30),
  ('beer', 52, 10),
  ('suntan cream', 11, 70),
  ('camera', 32, 30),
  ('T-shirt', 24, 15),
  ('trousers', 48, 10),
  ('umbrella', 73, 40),
  ('waterproof trousers', 42, 70),
  ('waterproof overclothes', 43, 75),
  ('note-case', 22, 80),
  ('sunglasses', 7, 20),
  ('towel', 18, 12),
  ('socks', 4, 50),
  ('book', 30, 10)|;
  maxweight = 400;

function m(i, w: integer): (List<item>, integer, integer);
begin
  var chosen := new List<item>;
  if (i < 0) or (w = 0) then
    result := (chosen, 0, 0)
  else if (wants[i].Item2 > w) then
    result := m(i - 1, w)
  else
  begin
    var (l0, w0, v0) := m(i - 1, w);
    var (l1, w1, v1) := m(i - 1, w - wants[i].Item2);
    v1 += wants[i].Item3;
    if (v1 > v0) then
    begin
      l1.Add(wants[i]);
      result := (l1, w1 + wants[i].Item2, v1);
    end
    else result := (l0, w0, v0);
  end;
end;

begin
  var (chosenItems, totalWeight, totalValue) := m(wants.Count - 1, maxweight);
  println('Knapsack Item Chosen    Weight Value');
  println('----------------------  ------ -----');
  foreach var it in chosenItems do
    writeln(it.Item1.PadRight(22), it.Item2:7, it.Item3:6);
  println('----------------------  ------ -----');
  writeln('Total ', chosenItems.Count, ' Items Chosen', totalWeight:8, totalValue:6);
end.
