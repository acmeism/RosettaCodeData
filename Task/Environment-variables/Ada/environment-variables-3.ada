with Ada.Wide_Wide_Text_IO;

with League.Application;
with League.Strings;

procedure Main is

   function "+"
    (Item : Wide_Wide_String) return League.Strings.Universal_String
       renames League.Strings.To_Universal_String;

begin
   Ada.Wide_Wide_Text_IO.Put_Line
    (League.Application.Environment.Value (+"HOME").To_Wide_Wide_String);
end Main;
