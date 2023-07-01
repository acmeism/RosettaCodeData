with Ada.Text_IO;
with Long_Multiplication;

procedure Test_Long_Multiplication is
   use Ada.Text_IO, Long_Multiplication;

   N : Number := Value ("18446744073709551616");
   M : Number := N * N;
begin
   Put_Line (Image (N) & " * " & Image (N) & " = " & Image (M));
end Test_Long_Multiplication;
