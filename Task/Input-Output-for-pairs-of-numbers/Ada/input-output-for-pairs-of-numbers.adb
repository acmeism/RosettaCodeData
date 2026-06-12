with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   count  : Integer;
   First  : Integer;
   Second : Integer;
begin
   Get (count);
   for I in 1 .. count loop
      Get (First);
      Get (Second);
      Put (Item => First + Second, Width => 1);
      New_Line;
   end loop;
end Main;
