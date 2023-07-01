with Ada.Text_IO;  use Ada.Text_IO;

procedure String_Concatenation is
   S1 : constant String := "Hello";
   S2 : constant String := S1 & " literal";
begin
   Put_Line (S1);
   Put_Line (S2);
end String_Concatenation;
