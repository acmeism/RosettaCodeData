package Polygons is

   type Point is record
      X, Y : Float;
   end record;
   type Point_List is array (Positive range <>) of Point;
   subtype Segment is Point_List (1 .. 2);
   type Polygon is array (Positive range <>) of Segment;

   function Create_Polygon (List : Point_List) return Polygon;

   function Is_Inside (Who : Point; Where : Polygon) return Boolean;

end Polygons;
