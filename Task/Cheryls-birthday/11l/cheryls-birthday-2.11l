with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   type Months is
     (January, February, March, April, May, June, July, August, September,
      November, December);
   type day_num is range 1 .. 31;
   type birthdate is record
      Month  : Months;
      Day    : day_num;
      Active : Boolean;
   end record;

   type birthday_list is array (Positive range <>) of birthdate;

   Possible_birthdates : birthday_list :=
     ((May, 15, True), (May, 16, True), (May, 19, True), (June, 17, True),
      (June, 18, True), (July, 14, True), (July, 16, True), (August, 14, True),
      (August, 15, True), (August, 17, True));

   procedure print_answer is
   begin
      for the_day of Possible_birthdates loop
         if the_day.Active then
            Put_Line (the_day.Month'Image & "," & the_day.Day'Image);
         end if;
      end loop;
   end print_answer;

   procedure print_remaining is
      count : Natural := 0;
   begin
      for date of Possible_birthdates loop
         if date.Active then
            count := count + 1;
         end if;
      end loop;
      Put_Line (count'Image & " remaining.");
   end print_remaining;

   -- the month cannot have a unique day
   procedure first_pass is
      count : Natural;
   begin
      for first_day of Possible_birthdates loop
         count := 0;
         for next_day of Possible_birthdates loop
            if first_day.Day = next_day.Day then
               count := count + 1;
            end if;
         end loop;

         if count = 1 then
            for the_day of Possible_birthdates loop
               if the_day.Active and then first_day.Month = the_day.Month then
                  the_day.Active := False;
               end if;
            end loop;
         end if;
      end loop;
   end first_pass;

   -- the day must now be unique
   procedure second_pass is
      count : Natural;
   begin
      for first_day of Possible_birthdates loop
         if first_day.Active then
            count := 0;
            for next_day of Possible_birthdates loop
               if next_day.Active then
                  if next_day.Day = first_day.Day then
                     count := count + 1;
                  end if;
               end if;
            end loop;

            if count > 1 then
               for next_day of Possible_birthdates loop
                  if next_day.Active and then next_day.Day = first_day.Day then
                     next_day.Active := False;
                  end if;
               end loop;
            end if;
         end if;
      end loop;
   end second_pass;

   -- the month must now be unique
   procedure third_pass is
      count : Natural;
   begin
      for first_day of Possible_birthdates loop
         if first_day.Active then
            count := 0;
            for next_day of Possible_birthdates loop
               if next_day.Active and then next_day.Month = first_day.Month
               then
                  count := count + 1;
               end if;
            end loop;
            if count > 1 then
               for next_day of Possible_birthdates loop
                  if next_day.Active and then next_day.Month = first_day.Month
                  then
                     next_day.Active := False;
                  end if;
               end loop;
            end if;
         end if;
      end loop;
   end third_pass;

begin
   print_remaining;
   first_pass;

   print_remaining;
   second_pass;

   print_remaining;
   third_pass;

   print_answer;
end Main;
