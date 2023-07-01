-----------------------------------------------------------------------
-- Angle difference between two bearings
-----------------------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;

procedure Bearing_Angles is
   type Real is digits 8;
   Package Real_Io is new Ada.Text_IO.Float_IO(Real);
   use Real_IO;
   type Angles is record
      B1 : Real;
      B2 : Real;
   end record;
   type Angle_Arr is array(Positive range <>) of Angles;

   function fmod(Left, Right : Real) return Real is
      Result : Real;
   begin
      Result := Left - Right*Real'Truncation(Left / Right);
      return Result;
   end fmod;

   The_Angles : Angle_Arr := ((20.0,45.0),(-45.0, 45.0), (-85.0, 90.0),
                              (-95.0, 90.0), (-14.0, 125.0), (29.4803, -88.6381),
                              (-78.3251, -159.036),
                              (-70099.74233810938, 29840.67437876723),
                              (-165313.6666297357, 33693.9894517456),
                              (1174.8380510598456, -154146.66490124757),
                              (60175.77306795546, 42213.07192354373));
   Diff : Real;

begin

   for A of The_Angles loop
      Diff := fmod(A.b2 - A.b1, 360.0);
      If Diff < -180.0 then
         Diff := Diff + 360.0;
      elsif Diff > 180.0 then
         Diff := Diff - 360.0;
      end if;

      Put("Difference between ");
      Put(Item => A.B2, Fore => 7, Aft => 4, Exp => 0);
      Put(" and ");
      Put(Item => A.B1, Fore => 7, Aft => 4, Exp => 0);
      Put(" is ");
      Put(Item => Diff, Fore => 4, Aft => 4, Exp => 0);
      New_Line;
   end loop;

end Bearing_Angles;
