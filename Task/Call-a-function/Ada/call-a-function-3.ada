type Integer_Array is array (Positive range <>) of Integer;
function Sum(A: Integer_Array) return Integer is
   S: Integer := 0;
begin
   for I in A'Range loop
      S := S + A(I);
   end loop;
   return S;
end Sum;
...
A := Sum((1,2,3));     -- A = 6
B := Sum((1,2,3,4));   -- B = 10
