with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Convex_Hull is

   type Point is record
      X, Y : Integer;
   end record;

   package Point_Vectors is
      new Ada.Containers.Vectors (Index_Type   => Positive,
                                  Element_Type => Point);
   use Point_Vectors;

   function Find_Convex_Hull (Vec : in Vector) return Vector is

      function Counter_Clock_Wise (A, B, C : in Point) return Boolean is
         ((B.X - A.X) * (C.Y - A.Y) > (B.Y - A.Y) * (C.X - A.X));

      function Less_Than (Left, Right : Point) return Boolean is
         (Left.X < Right.X);

      package Sorter is
         new Point_Vectors.Generic_Sorting (Less_Than);

      Sorted : Vector := Vec;
      Result : Vector := Empty_vector;
      use type Ada.Containers.Count_Type;
   begin
      if Vec = Empty_Vector then
         return Empty_Vector;
      end if;

      Sorter.Sort (Sorted);

      --  Lower hull
      for Index in Sorted.First_Index .. Sorted.Last_Index loop
         while
           Result.Length >= 2 and then
           not Counter_Clock_Wise (Result (Result.Last_Index - 1),
                                   Result (Result.Last_Index),
                                   Sorted (Index))
         loop
            Result.Delete_Last;
         end loop;
         Result.Append (Sorted (Index));
      end loop;

      --  Upper hull
      declare
         T : constant Ada.Containers.Count_Type := Result.Length + 1;
      begin
         for Index in reverse Sorted.First_Index .. Sorted.Last_Index loop
            while
              Result.Length >= T and then
              not Counter_Clock_Wise (Result (Result.Last_Index - 1),
                                      Result (Result.Last_Index),
                                      Sorted (Index))
            loop
               Result.Delete_Last;
            end loop;
            Result.Append (Sorted (Index));
         end loop;
      end;

      Result.Delete_Last;
      return Result;
   end Find_Convex_Hull;

   procedure Show (Vec : in Vector) is
      use Ada.Text_IO;
   begin
      Put ("[ ");
      for Point of Vec loop
         Put ("(" & Point.X'Image & "," & Point.Y'Image & ")");
      end loop;
      Put (" ]");
   end Show;

   Vec : constant Vector :=
     (16, 3) & (12,17) & ( 0, 6) & (-4,-6) & (16, 6) &
     (16,-7) & (16,-3) & (17,-4) & ( 5,19) & (19,-8) &
     ( 3,16) & (12,13) & ( 3,-4) & (17, 5) & (-3,15) &
     (-3,-9) & ( 0,11) & (-9,-3) & (-4,-2) & (12,10);
begin
   Show (Find_Convex_Hull (Vec));
   Ada.Text_IO.New_Line;
end Convex_Hull;
