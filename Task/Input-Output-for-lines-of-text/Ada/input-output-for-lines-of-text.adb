--
-- The first line contains the number of lines to follow, followed by that
-- number of lines of text on   STDIN.
--
-- Write to   STDOUT   each line of input by passing it to a method as an
-- intermediate step. The code should demonstrate these 3 things.
--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   Num_Lines : Integer;
begin
   Get(Num_Lines);
   Skip_Line;
   for I in 1..Num_Lines loop
      Put_Line(Get_Line);
   end loop;
end Main;
