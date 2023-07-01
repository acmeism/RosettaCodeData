type Unconstrained_Vector is array (Positive range <>) of Integer;
U1 : Unconstrained_Vector := (1,2,3,4,5,6,7,8,9,10);
U2 : Unconstrained_Vector := (10,11,12,13);
...
function "*" (Left : Unconstrained_Vector; Right : Integer) return Unconstrained_Vector is
   Result : Unconstrained_Vector(Left'Range);
begin
   for I in Left'Range loop
      Result(I) := Left(I) * Right;
   end loop;
   return Result;
end "*";
