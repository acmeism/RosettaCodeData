with Ada.Numerics.Generic_Real_Arrays;
with Ada.Text_IO;

procedure Intersection is

   type Real is new Long_Float;

   package Real_Arrays is
      new Ada.Numerics.Generic_Real_Arrays (Real => Real);
   use Real_Arrays;

   package Real_IO is
      new Ada.Text_IO.Float_IO (Num => Real);

   subtype Vector_3D is Real_Vector (1 .. 3);

   function Line_Plane_Intersection (Line_Vector  : in Vector_3D;
                                     Line_Point   : in Vector_3D;
                                     Plane_Normal : in Vector_3D;
                                     Plane_Point  : in Vector_3D)
                                    return Vector_3D
   is
      Diff  : constant Vector_3D := Line_Point - Plane_Point;
      Denom : constant Real      := Line_Vector * Plane_Normal;
   begin
      if Denom = 0.0 then
         raise Constraint_Error with "Line does not intersect plane";
      end if;
      declare
         Scale : constant Real :=
           -Real'(Diff * Plane_Normal) / Denom;
         Point : constant Vector_3D :=
           Diff + Plane_Point + Scale * Line_Vector;
      begin
         return Point;
      end;
   end Line_Plane_Intersection;

   procedure Put (V : in Vector_3D) is
      use Ada.Text_IO, Real_IO;
   begin
      Put ("(");
      Put (V (1));  Put (",");
      Put (V (2));  Put (",");
      Put (V (3));  Put (")");
   end Put;

begin
   Real_IO.Default_Exp := 0;
   Real_IO.Default_Aft := 3;

   Put (Line_Plane_Intersection (Line_Vector  => (0.0, -1.0, -1.0),
                                 Line_Point   => (0.0,  0.0, 10.0),
                                 Plane_Normal => (0.0,  0.0,  1.0),
                                 Plane_Point  => (0.0,  0.0,  5.0)));
end Intersection;
