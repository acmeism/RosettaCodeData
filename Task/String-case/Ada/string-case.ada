with Ada.Characters.Handling, Ada.Text_IO;
use  Ada.Characters.Handling, Ada.Text_IO;

procedure Upper_Case_String is
   S : constant String := "alphaBETA";
begin
   Put_Line (To_Upper (S));
   Put_Line (To_Lower (S));
end Upper_Case_String;
