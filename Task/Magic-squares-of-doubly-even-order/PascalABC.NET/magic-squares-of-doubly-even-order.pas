const
  n = 8;

function MagicSquareDoublyEven(n: integer): array [,] of integer;
begin
  assert((n >= 4) and (n mod 4 = 0), 'base must be a positive multiple of 4');

  // pattern of count-up vs count-down zones
  var bits := Convert.ToInt32('1001011001101001', 2);
  var size := n * n;
  var mult := n div 4;  // how many multiples of 4

  result := new integer[n, n];

  var i := 0;
  for var r := 0 to n - 1 do
    for var c := 0 to n - 1 do
    begin
      var bitPos := c div mult + (r div mult) * 4;
      result[r, c] := if (bits and (1 shl bitPos)) <> 0 then i + 1 else size - i;
      i += 1;
    end;
end;

begin
  MagicSquareDoublyEven(n).Println;

  Writeln(#10, 'Magic constant: ', (n * n + 1) * n div 2);
end.
