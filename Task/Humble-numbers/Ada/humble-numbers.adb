with Ada.Text_IO;

procedure Show_Humble is

   type Positive is range 1 .. 2**63 - 1;
   First : constant Positive := Positive'First;
   Last  : constant Positive := 999_999_999;

   function Is_Humble (I : in Positive) return Boolean is
   begin
      if    I <= 1      then  return True;
      elsif I mod 2 = 0 then  return Is_Humble (I / 2);
      elsif I mod 3 = 0 then  return Is_Humble (I / 3);
      elsif I mod 5 = 0 then  return Is_Humble (I / 5);
      elsif I mod 7 = 0 then  return Is_Humble (I / 7);
      else                    return False;
      end if;
   end Is_Humble;

   subtype Digit_Range is Natural range First'Image'Length - 1 .. Last'Image'Length - 1;
   Digit_Count  : array (Digit_Range) of Natural := (others => 0);

   procedure Count_Humble_Digits is
      use Ada.Text_IO;
      Humble_Count : Natural := 0;
      Len : Natural;
   begin
      Put_Line ("The first 50 humble numbers:");
      for N in First .. Last loop
         if Is_Humble (N) then
            Len := N'Image'Length - 1;
            Digit_Count (Len) := Digit_Count (Len) + 1;

            if Humble_Count < 50 then
               Put (N'Image);
               Put (" ");
            end if;
            Humble_Count := Humble_Count + 1;
         end if;
      end loop;
      New_Line (2);
   end Count_Humble_Digits;

   procedure Show_Digit_Counts is
      package Natural_IO is
         new Ada.Text_IO.Integer_IO (Natural);
      use Ada.Text_IO;
      use Natural_IO;

      Placeholder : String := "Digits Count";
      Image_Digit : String renames Placeholder (1 .. 6);
      Image_Count : String renames Placeholder (8 .. Placeholder'Last);
   begin
      Put_Line ("The digit counts of humble numbers:");
      Put_Line (Placeholder);
      for Digit in Digit_Count'Range loop
         Put (Image_Digit, Digit);
         Put (Image_Count, Digit_Count (Digit));
         Put_Line (Placeholder);
      end loop;
   end Show_Digit_Counts;

begin
   Count_Humble_Digits;
   Show_Digit_Counts;
end Show_Humble;
