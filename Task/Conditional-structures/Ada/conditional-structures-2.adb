type Operation is (Add, Subtract, Multiply, Divide);
Op : Operation;
Result : Integer;
-- we assume that A and B are inputs.
Result := (if Op = Add then
  A + B
elsif Op = Subtract then
  A - B
elsif Op = Multiply then
  A * B
elsif Op = Divide then
  A / B
);
