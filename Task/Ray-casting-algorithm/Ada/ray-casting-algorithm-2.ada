package body Polygons is
   EPSILON : constant := 0.00001;

   function Ray_Intersects_Segment
     (Who   : Point;
      Where : Segment)
      return  Boolean
   is
      The_Point        : Point   := Who;
      Above            : Point;
      Below            : Point;
      M_Red            : Float;
      Red_Is_Infinity  : Boolean := False;
      M_Blue           : Float;
      Blue_Is_Infinity : Boolean := False;
   begin
      if Where (1).Y < Where (2).Y then
         Above := Where (2);
         Below := Where (1);
      else
         Above := Where (1);
         Below := Where (2);
      end if;
      if The_Point.Y = Above.Y or The_Point.Y = Below.Y then
         The_Point.Y := The_Point.Y + EPSILON;
      end if;
      if The_Point.Y < Below.Y or The_Point.Y > Above.Y then
         return False;
      elsif The_Point.X > Above.X and The_Point.X > Below.X then
         return False;
      elsif The_Point.X < Above.X and The_Point.X < Below.X then
         return True;
      else
         if Above.X /= Below.X then
            M_Red := (Above.Y - Below.Y) / (Above.X - Below.X);
         else
            Red_Is_Infinity := True;
         end if;
         if Below.X /= The_Point.X then
            M_Blue := (The_Point.Y - Below.Y) / (The_Point.X - Below.X);
         else
            Blue_Is_Infinity := True;
         end if;
         if Blue_Is_Infinity then
            return True;
         elsif Red_Is_Infinity then
            return False;
         elsif M_Blue >= M_Red then
            return True;
         else
            return False;
         end if;
      end if;
   end Ray_Intersects_Segment;

   function Create_Polygon (List : Point_List) return Polygon is
      Result : Polygon (List'Range);
      Side   : Segment;
   begin
      for I in List'Range loop
         Side (1) := List (I);
         if I = List'Last then
            Side (2) := List (List'First);
         else
            Side (2) := List (I + 1);
         end if;
         Result (I) := Side;
      end loop;
      return Result;
   end Create_Polygon;

   function Is_Inside (Who : Point; Where : Polygon) return Boolean is
      Count : Natural := 0;
   begin
      for Side in Where'Range loop
         if Ray_Intersects_Segment (Who, Where (Side)) then
            Count := Count + 1;
         end if;
      end loop;
      if Count mod 2 = 0 then
         return False;
      else
         return True;
      end if;
   end Is_Inside;

end Polygons;
