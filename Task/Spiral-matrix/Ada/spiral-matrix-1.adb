-- Spiral Square
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

procedure Spiral_Square is
   type Array_Type is array(Positive range <>, Positive range <>) of Natural;

   function Spiral (N : Positive) return Array_Type is
      Result  : Array_Type(1..N, 1..N);
      Row     : Natural := 1;
      Col     : Natural := 1;
      Max_Row : Natural := N;
      Max_Col : Natural := N;
      Min_Row : Natural := 1;
      Min_Col : Natural := 1;
   begin
      for I in 0..N**2 - 1 loop
         Result(Row, Col) := I;
         if Row = Min_Row then
            Col := Col + 1;
            if Col > Max_Col then
               Col := Max_Col;
               Row := Row + 1;
            end if;
         elsif Col = Max_Col then
            Row := Row + 1;
            if Row > Max_Row then
               Row := Max_Row;
               Col := Col - 1;
            end if;
         elsif Row = Max_Row then
            Col := Col - 1;
            if Col < Min_Col then
               Col := Min_Col;
               Row := Row - 1;
            end if;
         elsif Col = Min_Col then
            Row := Row - 1;
            if Row = Min_Row then  -- Reduce spiral
               Min_Row := Min_Row + 1;
               Max_Row := Max_Row - 1;
               Row := Min_Row;
               Min_Col := Min_Col + 1;
               Max_Col := Max_Col - 1;
               Col := Min_Col;
            end if;
         end if;
      end loop;
      return Result;
   end Spiral;

   procedure Print(Item : Array_Type) is
      Num_Digits : constant Float := Log(X => Float(Item'Length(1)**2), Base => 10.0);
      Spacing    : constant Positive := Integer(Num_Digits) + 2;
   begin
      for I in Item'range(1) loop
         for J in Item'range(2) loop
            Put(Item => Item(I,J), Width => Spacing);
         end loop;
         New_Line;
      end loop;
   end Print;

begin
   Print(Spiral(5));
end Spiral_Square;
