with parent.child;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Num    : Integer := 5;
   Result : Integer;
begin
   Put_Line ("Calling parent Add2 function:");
   Result := parent.Add2 (Num);
   Put_Line ("Result : " & Result'Image);
   New_Line;
   Put_Line ("Calling parent.child Add2 function");
   Result := parent.child.Add2 (Num);
   Put_Line ("Result : " & Result'Image);
end Main;
