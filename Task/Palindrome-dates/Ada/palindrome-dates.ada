with Ada.Text_IO;
with Ada.Calendar.Formatting;
with Ada.Calendar.Arithmetic;

procedure Palindrome_Dates is
   Desired_Count : constant := 15;
   Start_Date    : constant String := "2020-01-01 00:00:00";

   use Ada.Calendar;

   function Is_Palindrome_Date (Date : Time) return Boolean is
      Image : String renames Formatting.Image (Date);
   begin
      return
        Image (1) = Image (10) and
        Image (2) = Image (9)  and
        Image (3) = Image (7)  and
        Image (4) = Image (6);
   end Is_Palindrome_Date;

   Date  : Ada.Calendar.Time := Formatting.Value (Start_Date);
   Count : Natural := 0;

   use type Ada.Calendar.Arithmetic.Day_Count;
begin
   loop
      if Is_Palindrome_Date (Date) then
         Ada.Text_IO.Put_Line (Formatting.Image (Date) (1 .. 10));
         Count := Count + 1;
      end if;
      exit when Count = Desired_Count;
      Date := Date + 1;
   end loop;
end Palindrome_Dates;
