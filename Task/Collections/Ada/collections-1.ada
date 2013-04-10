procedure Array_Collection is

   A : array (-3 .. -1) of Integer := (1, 2, 3);

begin

   A (-3) := 3;
   A (-2) := 2;
   A (-1) := 1;

end Array_Collection;
