with Ada.Text_Io;
with Ada.Calendar.Formatting;

procedure Weekdays is
   use Ada.Text_Io;
   use Ada.Calendar.Formatting;

   subtype Time is Ada.Calendar.Time;

   procedure Info (Date : Time) is
   begin
      Put (Image (Date));
      Put (" is a ");
      Put (Day_Name'Image (Day_Of_Week (Date)));
      Put (".");
      New_Line;
   end Info;

   Christmas_Day : constant Time := Time_Of (Year => 2021, Month => 12, Day => 25);
   New_Years_Day : constant Time := Time_Of (Year => 2022, Month => 01, Day => 01);

begin
   Info (Christmas_Day);
   Info (New_Years_Day);
end Weekdays;
