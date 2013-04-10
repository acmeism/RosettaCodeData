with Ethiopian; use Ethiopian;
with Ada.Text_Io; use Ada.Text_Io;

procedure Ethiopian_Test is
   First  : Integer := 17;
   Second : Integer := 34;
begin
   Put_Line(Integer'Image(First) & " times " &
      Integer'Image(Second) & " = " &
      Integer'Image(Multiply(First, Second)));
end Ethiopian_Test;
