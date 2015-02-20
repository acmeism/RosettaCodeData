with Ada.Text_IO; with Mod_Inv; use Mod_Inv, Ada.text_IO;

procedure Mod_Inv_Test is
begin
   -- Put_Line(Natural'Image(Inverse(154, 3311)));
   -- The above would raise CONSTRAINT_ERROR : GCD ( 154, 3311 ) = 77 /= 1

   Put_Line(Natural'Image(Inverse(42, 2017)));
end Mod_Inv_Test;
