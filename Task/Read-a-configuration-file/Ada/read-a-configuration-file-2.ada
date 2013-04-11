with Ada.Text_IO;
with Config;                   use Config;

procedure Read_Config is
   use Ada.Text_IO;
   use Rosetta_Config;

begin
   New_Line;
   Put_Line ("Reading Configuration File.");
   Put_Line ("Fullname       := " & Get (Key => FULLNAME));
   Put_Line ("Favorite Fruit := " & Get (Key => FAVOURITEFRUIT));
   Put_Line ("Other Family   := " & Get (Key => OTHERFAMILY));
   if Has_Value (Key => NEEDSPEELING) then
      Put_Line ("NEEDSPEELLING  := " & Get (Key => NEEDSPEELING));
   else
      Put_Line ("NEEDSPEELLING  := True");
   end if;
   if Has_Value (Key => SEEDSREMOVED) then
      Put_Line ("SEEDSREMOVED   := " & Get (Key => SEEDSREMOVED));
   else
      Put_Line ("SEEDSREMOVED   := True");
   end if;
end Read_Config;
