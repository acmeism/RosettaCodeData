-- Report the number of decimal places in a number
-- J. Carter     2023 Apr
-- I presume the input is a String containing the image of the value; the test values of 12.345 & 12.3450 represent the same number,
-- and so would give the same result otherwise

with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure Decimal_Places is
   function Num_Places (Number : in String) return Natural;
   -- Returns the number of decimal places in the numeric image in Number

   function Num_Places (Number : in String) return Natural is
      Dot : constant Natural := Ada.Strings.Fixed.Index (Number, ".");
   begin -- Num_Places
      if Dot = 0 then
         return 0;
      end if;

      return Number'Last - Dot;
   end Num_Places;

   Test_1 : constant String := "12.345";
   Test_2 : constant String := "12.3450";
begin -- Decimal_Places
   Ada.Text_IO.Put_Line (Item => Test_1 & (1 .. 10 - Test_1'Length => ' ') & Num_Places (Test_1)'Image);
   Ada.Text_IO.Put_Line (Item => Test_2 & (1 .. 10 - Test_2'Length => ' ') & Num_Places (Test_2)'Image);
end Decimal_Places;
