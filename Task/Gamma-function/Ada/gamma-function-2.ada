with Ada.Text_IO;  use Ada.Text_IO;
with Gamma;

procedure Test_Gamma is
begin
   for I in 1..10 loop
      Put_Line (Long_Float'Image (Gamma (Long_Float (I) / 3.0)));
   end loop;
end Test_Gamma;
