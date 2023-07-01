with Ada.Calendar.Formatting;
with Ada.Command_Line;
with Ada.Numerics.Elementary_Functions;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure Mean_Time_Of_Day is

   subtype Time        is Ada.Calendar.Time;
   subtype Time_Of_Day is Ada.Calendar.Day_Duration;
   subtype Time_String is String (1 .. 8);  --  "HH:MM:SS"

   type Time_List is array (Positive range <>) of Time_String;

   function Average_Time (List : Time_List) return Time_String is

      function To_Time (Time_Image : Time_String) return Time
      is (Ada.Calendar.Formatting.Value ("2000-01-01 " & Time_Image));

      function To_Time_Of_Day (TS : Time) return Time_Of_Day is
         use Ada.Calendar.Formatting;
         Hour_Part : constant Time_Of_Day := 60.0 * 60.0 * Hour (TS);
         Min_Part  : constant Time_Of_Day := 60.0 * Minute (TS);
         Sec_Part  : constant Time_Of_Day := Time_Of_Day (Second (TS));
      begin
         return Hour_Part + Min_Part + Sec_Part;
      end To_Time_Of_Day;

      function To_Time_Image (Angle : Time_Of_Day) return Time_String
      is
         use Ada.Calendar.Formatting;
         TOD : constant Time := Time_Of
           (Year => 2000, Month => 1, Day => 1,  --  Not used
            Seconds => Angle);
      begin
         return Ada.Strings.Fixed.Tail (Image (TOD), Time_String'Length);
      end To_Time_Image;

      function Average_Time_Of_Day (List : Time_List) return Time_Of_Day is
         use Ada.Numerics.Elementary_Functions;
         Cycle : constant Float := Float (Time_Of_Day'Last);
         X_Sum, Y_Sum : Float := 0.0;
         Angle        : Float;
      begin
         for Time_Stamp of List loop
            Angle := Float (To_Time_Of_Day (To_Time (Time_Stamp)));
            X_Sum := X_Sum + Cos (Angle, Cycle => Cycle);
            Y_Sum := Y_Sum + Sin (Angle, Cycle => Cycle);
         end loop;
         Angle := Arctan (Y_Sum, X_Sum, Cycle => Cycle);
         if Angle < 0.0 then
            Angle := Angle + Cycle;
         elsif Angle > Cycle then
            Angle := Angle - Cycle;
         end if;
         return Time_Of_Day (Angle);
      end Average_Time_Of_Day;

   begin
      return To_Time_Image (Average_Time_Of_Day (List));
   end Average_Time;

   use Ada.Command_Line;
   List : Time_List (1 .. Argument_Count);
begin
   if Argument_Count = 0 then
      raise Constraint_Error;
   end if;

   for A in 1 .. Argument_Count loop
      List (A) := Argument (A);
   end loop;
   Ada.Text_IO.Put_Line (Average_Time (List));

exception
   when others =>
      Ada.Text_IO.Put_Line ("Usage: mean_time_of_day <time-1> ...");
      Ada.Text_IO.Put_Line ("       <time-1> ...   'HH:MM:SS' format");
end Mean_Time_Of_Day;
