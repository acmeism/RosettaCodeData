program Sum3sAnd5s;

function Multiple(x, y: integer): Boolean;
  { Is X a multiple of Y? }
   begin
      Multiple := (X mod Y) = 0
   end;

function SumMultiples(n: integer): longint;
  { Return the sum of all multiples of 3 or 5. }
   var i: integer; sum: longint;
   begin
      sum := 0;
      for i := 1 to pred(n) do
         if Multiple(i, 3) or Multiple(i, 5) then
           sum := sum + i;
      SumMultiples := sum
   end;

begin
   { Show sum of all multiples less than 1000. }
   writeln(SumMultiples(1000))
end.
