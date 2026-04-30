with Ada.Text_IO;  use Ada.Text_IO;
procedure Test_Interval_Addition is
   -- Definitions from above
   procedure Put (I : Interval) is
   begin
      Put (Long_Float'Image (Long_Float (I.Lower)) & "," & Long_Float'Image (Long_Float (I.Upper)));
   end Put;
begin
   Put (1.14 + 2000.0);
end Test_Interval_Addition;
