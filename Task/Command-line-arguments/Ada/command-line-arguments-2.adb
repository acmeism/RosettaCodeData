with Ada.Wide_Wide_Text_IO;

with League.Application;
with League.Strings;

procedure Main is
begin
   for J in 1 .. League.Application.Arguments.Length loop
      Ada.Wide_Wide_Text_IO.Put_Line
       (League.Application.Arguments.Element (J).To_Wide_Wide_String);
   end loop;
end Main;
