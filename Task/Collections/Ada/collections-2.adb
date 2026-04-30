procedure Array_Collection is

   type Array_Type is array (1 .. 3) of Integer;
   A : Array_Type := (1, 2, 3);

begin

   A (1) := 3;
   A (2) := 2;
   A (3) := 1;

end Array_Collection;
