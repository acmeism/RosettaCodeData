program Sierpinski;

function ipow(b, n	: Integer) : Integer;
var
   i : Integer;
begin
   ipow := 1;
   for i := 1 to n do
      ipow := ipow * b
end;

function truth(a : Char) : Boolean;
begin
   if a = '*' then
      truth := true
   else
      truth := false
end;
