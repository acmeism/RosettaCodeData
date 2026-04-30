with Ada.Calendar;
with Ada.Calendar.Arithmetic;
with Ada.Calendar.Formatting;
with Ada.Command_Line;
with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;

use Ada.Calendar;
use Ada.Calendar.Arithmetic;
use Ada.Calendar.Formatting;
use Ada.Command_Line;
use Ada.Numerics;
use Ada.Numerics.Elementary_Functions;
use Ada.Text_IO;

procedure Biorhythms is
   Birth_Date : Time := Value (Argument (1) & " 00:00:00");
   Target_Date : Time := Value (Argument (2) & " 00:00:00");
   Days : Day_Count := Target_Date - Birth_Date;

   --  There's not much point having types for these for such a short
   --  problem, but in a big program this would be useful to prevent
   --  accidentally assigning wrong values.
   type Physical_Type is mod 23;
   type Emotional_Type is mod 28;
   type Mental_Type is mod 33;
   type Biorhythm_Type is
      record
         Physical : Physical_Type;
         Emotional : Emotional_Type;
         Mental : Mental_Type;
      end record;

   function To_Biorhythm (D : Day_Count) return Biorhythm_Type is
      (
       Physical_Type (D mod Physical_Type'Modulus),
       Emotional_Type (D mod Emotional_Type'Modulus),
       Mental_Type (D mod Mental_Type'Modulus)
      );

   Biorhythm : Biorhythm_Type := To_Biorhythm (Days);

   package Float_IO is new Ada.Text_IO.Float_IO (Float);
   use Float_IO;

   function To_Percent (F : Float) return Float is
     (100.0 * Sin (2.0 * Pi * F));

   procedure Report_Biorhythm (B : Biorhythm_Type) is
      PFrac : Float := Float (B.Physical) / Float (Physical_Type'Modulus);
      EFrac : Float := Float (B.Emotional) / Float (Emotional_Type'Modulus);
      MFrac : Float := Float (B.Mental) / Float (Mental_Type'Modulus);
      Physical : Float := To_Percent (PFrac);
      Emotional : Float := To_Percent (EFrac);
      Mental : Float := To_Percent (MFrac);
   begin
      Put_Line ("Age in days: " & Days'Image);
      Put ("Physical cycle: "); Put (Physical, 3, 1, 0); Put ("%"); New_Line;
      Put ("Emotional cycle: "); Put (Emotional, 3, 1, 0); Put ("%"); New_Line;
      Put ("Mental cycle: "); Put (Mental, 3, 1, 0); Put ("%"); New_Line;
   end Report_Biorhythm;
begin
   Report_Biorhythm (Biorhythm);
end Biorhythms;
