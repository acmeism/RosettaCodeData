function halve(x: integer): integer := x div 2;
function double(x: integer): integer := x * 2;
function odd(x: integer): boolean := x mod 2 <> 0;

function ethiopian(x, y: integer): integer;
begin
  while x >= 1 do
  begin
    if odd(x) then result += y;
    x := halve(x);
    y := double(y);
  end;
end;

begin
  ethiopian(17, 34).println;
end.
