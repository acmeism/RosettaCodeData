-------------------------------------------------------------
-- Calculate long years
-- Reference: https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
-------------------------------------------------------------
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

procedure Main is
   First_Day : Time;
   Last_Day  : Time;
   package AC renames Ada.Calendar;
   type Counter is mod 10;
   Count : Counter := 0;
begin
   for Yr in Year_Number loop

      First_Day := AC.Time_Of (Year => Yr, Month => 1, Day => 1);
      Last_Day  := AC.Time_Of (Year => Yr, Month => 12, Day => 31);

      -- If Jan 1 is Thursday or Dec 31 is Thursday then
      -- the year is a long year

      if Day_Of_Week (First_Day) = Thursday
        or else Day_Of_Week (Last_Day) = Thursday
      then
         if Count = 0 then
            New_Line;
         end if;
         Put (Yr'Image);
         Count := Count + 1;
      end if;
   end loop;
end Main;
