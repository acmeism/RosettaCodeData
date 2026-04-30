with Ada.Text_IO;

procedure Shoelace_Formula_For_Polygonal_Area
is
   type Point is record
      x, y : Float;
   end record;

   type Polygon is array (Positive range <>) of Point;

   function Shoelace(input : in Polygon) return Float
   is
      sum_1 : Float := 0.0;
      sum_2 : Float := 0.0;
      tmp : constant Polygon := input & input(input'First);
   begin
      for I in tmp'First .. tmp'Last - 1 loop
         sum_1 := sum_1 + tmp(I).x * tmp(I+1).y;
         sum_2 := sum_2 + tmp(I+1).x * tmp(I).y;
      end loop;
      return abs(sum_1 - sum_2) / 2.0;
   end Shoelace;

   my_polygon : constant Polygon :=
     ((3.0, 4.0),
      (5.0, 11.0),
      (12.0, 8.0),
      (9.0, 5.0),
      (5.0, 6.0));
begin
   Ada.Text_IO.Put_Line(Shoelace(my_polygon)'Img);
end Shoelace_Formula_For_Polygonal_Area;
