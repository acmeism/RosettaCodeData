function delta(b1, b2: real): real;
begin
  result := (b2 - b1) - Trunc((b2 - b1) / 360.0) * 360.0;
  if result < -180.0 then result += 360.0
  else if result >= 180.0 then result -= 360.0
end;

begin
  var testVectors :=
  |(20.00, 45.00), (-45.00, 45.00), (-85.00, 90.00),
  (-95.00, 90.00), (-45.00, 125.00), (-45.00, 145.00),
  (29.48, -88.64), (-78.33, -159.04), (-70099.74, 29840.67),
  (-165313.67, 33693.99), (1174.84, -154146.66), (60175.77, 42213.07)|;
  foreach var vector in testVectors do
    writeln(vector[0]:10:2, vector[1]:12:2, delta(vector[0], vector[1]):10:2);
end.
