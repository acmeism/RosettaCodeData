with Ada.Text_Io;
with Ada.Numerics;

procedure Calculate_Arc_Length is
   use Ada.Text_Io;

   type Angle_Type is new Float range 0.0 .. 360.0;       -- In degrees
   type Distance   is new Float range 0.0 .. Float'Last;  -- In units

   function Major_Arc_Length (Angle_1, Angle_2 : Angle_Type;
                              Radius           : Distance)
                             return Distance
   is
      Pi            : constant := Ada.Numerics.Pi;
      Circumference : constant Distance   := 2.0 * Pi * Radius;
      Major_Angle   : constant Angle_Type := 360.0 - abs (Angle_2 - Angle_1);
      Arc_Length    : constant Distance   :=
        Distance (Major_Angle) / 360.0 * Circumference;
   begin
      return Arc_Length;
   end Major_Arc_Length;

   package Distance_Io is new Ada.Text_Io.Float_Io (Distance);

   Arc_Length : constant Distance := Major_Arc_Length (Angle_1 =>  10.0,
                                                       Angle_2 => 120.0,
                                                       Radius  =>  10.0);
begin
   Put ("Arc length : ");
   Distance_Io.Put (Arc_Length, Exp => 0, Aft => 4);
   New_Line;
end Calculate_Arc_Length;
