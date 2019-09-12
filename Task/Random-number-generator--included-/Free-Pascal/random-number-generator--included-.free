program RandomNumbers;
// Program to demonstrate the Random and Randomize functions.
var
  RandomInteger: integer;
  RandomFloat: double;
begin
  Randomize; // generate a new sequence every time the program is run
  RandomFloat := Random();       // 0 <= RandomFloat < 1
  Writeln('Random float between 0 and 1: ', RandomFloat: 5: 3);
  RandomFloat := Random() * 10;  // 0 <= RandomFloat < 10
  Writeln('Random float between 0 and 10: ', RandomFloat: 5: 3);
  RandomInteger := Random(10);   //  0 <= RandomInteger < 10
  Writeln('Random integer between 0 and 9: ', RandomInteger);
  // Wait for <enter>
  Readln;
end.
