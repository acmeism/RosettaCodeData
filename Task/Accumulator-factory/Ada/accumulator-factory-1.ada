with Accumulator;
with Ada.Text_IO; use Ada.Text_IO;

procedure Example is
   package A is new Accumulator;
   package B is new Accumulator;
begin
   Put_Line (Integer'Image (A.The_Function (5)));
   Put_Line (Integer'Image (B.The_Function (3)));
   Put_Line (Float'Image (A.The_Function (2.3)));
end;
