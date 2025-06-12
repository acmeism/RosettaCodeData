--  cistercian-ascii.ads
--  ASCII printout of Cistercian representations
--  this is generic, so that you can make it as large as you like
--  (within reason)

pragma Ada_2022;

with Cistercian.Ascii_Requirements;

generic
   Dimension : Cistercian.Ascii_Requirements.Valid_Dimension := 7;
package Cistercian.Ascii is

   type Block (<>) is private;
   --  as i understand it, this particular use of the discriminant
   --  prevents the client from instantiating a `Block` without
   --  going through one of our generator functions,
   --  and the only one of those is `Zero`

   function Zero return Block;
   --  returns a `Block` corresponding to 0;
   --  i.e., a vertical line through the center

   function From (Value : Cistercian.Representation) return Block;
   --  converts a Cistercian representation to an ASCII block

   procedure Put (Value : Cistercian.Representation);
   --  print the value to standard output

private

   Max : constant Integer := (Dimension - 1) / 2;
   --  the maximum coordinate we can access in any one dimension
   Mid : constant Integer := Max / 2 + 1;
   --  midway to `Max`, natch

   subtype Cistercian_Ascii_Range is Integer range -(Max + 1) .. (Max + 1);
   --  we leave some room for aesthetic reasons
   --  (i had another reason originally, but i don't think it applies anymore)

   type Block is
     array (Cistercian_Ascii_Range, Cistercian_Ascii_Range) of Boolean;
   --  an entry should be True iff it should be painted in a stroke

   function Zero return Block
   is
      --  just a vertical line in the middle
      ([for Row in Block'Range (1)
        => [for Col in Block'Range (2)
            => (if Col = 0 and then abs (Row) < Max + 1
                then True
                else False)]]);

end Cistercian.Ascii;
