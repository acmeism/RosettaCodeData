with Ada.Text_IO;  use Ada.Text_IO;

procedure Divide_By_Zero is
begin
   declare
      N : Integer := 1;
      D : Integer := 0;
   begin
      N := N / D;
   exception
      when Constraint_Error =>
         Put_Line ("Integer zero divide");
   end;
   declare
      type Sane_Float is new Float range Float'First..Float'Last;
      N : Sane_Float := 1.0;
      D : Sane_Float := 0.0;
   begin
      N := N / D;
   exception
      when Constraint_Error =>
         Put_Line ("Floating-point zero divide");
   end;
end Divide_By_Zero;
