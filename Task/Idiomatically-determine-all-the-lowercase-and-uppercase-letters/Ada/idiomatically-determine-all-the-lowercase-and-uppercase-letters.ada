with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   subtype Lower is Character range 'a' .. 'z';
   subtype Upper is Character range 'A' .. 'Z';
begin
   Put ("Lower: ");
   for c in Lower'range loop
      Put (c);
   end loop;
   New_Line;
   Put ("Upper: ");
   for c in Upper'range loop
      Put (c);
   end loop;
   New_Line;
end Main;
