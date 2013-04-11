with Ada.Text_IO;
procedure Integers is
   Value : Integer := 1;
begin
   loop
      Ada.Text_IO.Put_Line (Integer'Image (Value));
      Value := Value + 1;
   end loop;
end Integers;
