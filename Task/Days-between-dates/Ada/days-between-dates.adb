with Ada.Calendar;
with Ada.Text_IO;
with Ada.Integer_Text_IO;

with GNAT.Calendar.Time_IO;

procedure Days_Between_Dates is

   function Days_Between (Lower_Date  : in Ada.Calendar.Time;
                          Higher_Date : in Ada.Calendar.Time) return Integer
   is
      use Ada.Calendar;
      Diff : constant Duration := Higher_Date - Lower_Date;
   begin
      return Integer (Diff / Day_Duration'Last);
   end Days_Between;

   procedure Put_Days_Between (Lower_Date  : in String;
                               Higher_Date : in String;
                               Comment     : in String)
   is
      use Ada.Text_IO;
      use Ada.Integer_Text_IO;
      use GNAT.Calendar.Time_IO;

      Diff : constant Integer := Days_Between (Lower_Date  => Value (Lower_Date),
                                               Higher_Date => Value (Higher_Date));
   begin
      Put ("Days between " & Lower_Date & " and " & Higher_Date & " is ");
      Put (Diff, Width => 5);
      Put (" days  --  ");
      Put (Comment);
      New_Line;
   end Put_Days_Between;

begin
   Put_Days_Between ("1995-11-21", "1995-11-21", "Identical dates");
   Put_Days_Between ("2019-01-01", "2019-01-02", "Positive span");
   Put_Days_Between ("2019-01-02", "2019-01-01", "Negative span");
   Put_Days_Between ("2019-01-01", "2019-03-01", "Non-leap year");
   Put_Days_Between ("2020-01-01", "2020-03-01", "Leap year");
   Put_Days_Between ("1902-01-01", "1968-12-25", "Past");
   Put_Days_Between ("2090-01-01", "2098-12-25", "Future");
   Put_Days_Between ("1902-01-01", "2098-12-25", "Long span");
end Days_Between_Dates;
