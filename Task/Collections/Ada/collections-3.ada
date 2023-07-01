procedure Array_Collection is

   type Array_Type is array (positive range <>) of Integer; -- may be indexed with any positive
                                                            -- Integer value
   A : Array_Type(1 .. 3);  -- creates an array of three integers, indexed from 1 to 3

begin

   A (1) := 3;
   A (2) := 2;
   A (3) := 1;

end Array_Collection;
