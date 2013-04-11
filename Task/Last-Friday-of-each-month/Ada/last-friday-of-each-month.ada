with Ada.Text_IO; use Ada.Text_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
procedure Fridays is
   T : Ada.Calendar.Time;
   Year : Year_Number := Integer'Value (Argument (1));
   MLength : constant array (1 .. 12) of Positive :=
      (4 | 6 | 9 | 11 => 30, 2 => 28, others => 31);
begin
   for month in 1 .. 12 loop
      for day in reverse 1 .. MLength (month) loop
         T := Ada.Calendar.Time_Of (Year, month, day);
         if Day_Of_Week (T) = Friday then
            Put_Line (Image (Date => T)(1 .. 10)); exit;
         end if;
      end loop;
   end loop;
end Fridays;
