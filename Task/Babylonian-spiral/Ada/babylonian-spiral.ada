pragma Ada_2022;
with Ada.Containers.Vectors;
with Ada.Numerics;                      use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;                       use Ada.Text_IO;

procedure Babylonian_Spiral is

   type Fixed_10_4 is delta 10.0 ** (-4) digits 9;
   type Point is record
      X, Y : Integer;
   end record;
   type Points_Array is array (1 .. 10_000) of Point;
   Points : Points_Array := [1 => (0, 0), 2 => (0, 1), others => (0, 0)];
   Ante_Previous_Point, Previous_Point : Point;
   package Point_Vectors is new Ada.Containers.Vectors (Positive, Point);
   use Point_Vectors;
   Point_Vector, PVC    : Point_Vectors.Vector;
   Min_Radius           : Integer := 1;
   Previous_Dist        : Fixed_10_4;  --  The previous distance which must be exceeded
   Min_Dist, Tmp_Dist   : Fixed_10_4;
   Max_Angle, Tmp_Angle : Fixed_10_4;
   Tmp_Ix, Cand_Ix      : Integer;
   Fixed_Pi             : constant Fixed_10_4 := 3.1416;
   SVG_File             : File_Type;
   X, Y                 : Integer;

   function Distance (Point1, Point2 : Point) return Fixed_10_4 is
      (Fixed_10_4 (Sqrt (Float (Point2.X - Point1.X)**2 +
                         Float (Point2.Y - Point1.Y)**2)));

   function Generate_Square_Of_Points (Centre : Point; Max_Radius : Positive)
                                       return Point_Vectors.Vector is
      PV : Point_Vectors.Vector;
   begin
      for X in Centre.X - Max_Radius .. Centre.X + Max_Radius loop
         for Y in Centre.Y - Max_Radius .. Centre.Y + Max_Radius loop
            PV.Append ((X, Y), 1);
         end loop;
      end loop;
      return PV;
   end Generate_Square_Of_Points;

   function Atan2 (Y, X : Float) return Float is
      Res : Float;
   begin
      if X > 0.0 then Res := Arctan (Y / X);
      elsif X < 0.0 and then Y >= 0.0 then Res := Arctan (Y / X) + Pi;
      elsif X < 0.0 and then Y < 0.0  then Res := Arctan (Y / X) - Pi;
      elsif X = 0.0 and then Y > 0.0  then Res := Pi / 2.0;
      elsif X = 0.0 and then Y > 0.0  then Res := -Pi / 2.0;
      else Res := -Pi / 2.0;  --  Technically: Undefined
      end if;
      return Res;
   end Atan2;

   function Angle (Centre, P2, P3 : Point) return Fixed_10_4 is
      Res : Float;
   begin
      Res := Atan2 (Float (P3.Y) - Float (Centre.Y), Float (P3.X) - Float (Centre.X)) -
             Atan2 (Float (P2.Y) - Float (Centre.Y), Float (P2.X) - Float (Centre.X));
      return Fixed_10_4 (Res);
   end Angle;

   function Collinear (Pt1, Pt2, Pt3 : Point) return Boolean is
   begin
      if Pt1.X = Pt2.X and then Pt2.X = Pt3.X then
         return True;
      end if;
      if Pt1.Y = Pt2.Y and then Pt2.Y = Pt3.Y then
         return True;
      end if;
      return Pt1.X * (Pt2.Y - Pt3.Y) + Pt2.X * (Pt3.Y - Pt1.Y) + Pt3.X * (Pt1.Y - Pt2.Y) = 0;
   end Collinear;

begin
   for Point_Ix in 3 .. Points'Last loop
      Ante_Previous_Point := Points (Point_Ix - 2);
      Previous_Point := Points (Point_Ix - 1);
      Previous_Dist  := Distance (Points (Point_Ix - 1), Points (Point_Ix - 2));
      Min_Radius     := Integer (Previous_Dist);
      Min_Dist       := 99999.999;
      Max_Angle      := 0.0;

      --  examine surrounding points
      Point_Vector := Generate_Square_Of_Points (Previous_Point, Min_Radius + 4);
      for Pt of Point_Vector loop
         if not Collinear (Pt, Previous_Point, Ante_Previous_Point) then
            Tmp_Dist := Distance (Pt, Previous_Point);
            if Tmp_Dist > Previous_Dist     and then Tmp_Dist < Min_Dist then
               Min_Dist := Tmp_Dist;
            end if;
         end if;

      end loop;

      --  Grab closest Points
      PVC.Clear;
      for Pt of Point_Vector loop
         if Distance (Pt, Previous_Point) = Min_Dist then
            PVC.Append (Pt);
         end if;
      end loop;

      Tmp_Ix := 1;
      for Pt of PVC loop
         Tmp_Angle := Angle (Previous_Point, Ante_Previous_Point, Pt);
         if Tmp_Angle < -(Fixed_Pi) then
            Tmp_Angle := Tmp_Angle + (2.0 * Fixed_Pi);
         end if;
         if Tmp_Angle < Fixed_Pi and then Tmp_Angle > Max_Angle then
            Cand_Ix := Tmp_Ix;
            Max_Angle := Tmp_Angle;
         end if;
         Tmp_Ix := Tmp_Ix + 1;
      end loop;
      if Point_Ix < 41 then
         Put ("(" & PVC (Cand_Ix).X'Image & "," & PVC (Cand_Ix).Y'Image & ") ");
      end if;
      Points (Point_Ix) := PVC (Cand_Ix);
   end loop;
   Create (SVG_File, Out_File, "babylonian_spiral.svg");
   Put_Line (SVG_File, "<svg xmlns='http://www.w3.org/2000/svg' width='12000' height='15000'>");
   Put_Line (SVG_File, "<rect width='100%' height='100%' fill='white'/>");
   X := 500 + Points (1).X;
   Y := 10000 - Points (1).Y;
   Put (SVG_File, "<path stroke-width='2' stroke='black' fill='none' d='M" &
                  X'Image & "," & Y'Image);
   for Pt_Ix in 2 .. Points'Last loop
      X := 500 + Points (Pt_Ix).X;
      Y := 10000 - Points (Pt_Ix).Y;
      Put (SVG_File, " L" & X'Image & "," & Y'Image);
   end loop;
   Put_Line (SVG_File, "'/>\n</svg>");
   Close (SVG_File);
end Babylonian_Spiral;
