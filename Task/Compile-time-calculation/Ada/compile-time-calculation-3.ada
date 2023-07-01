with Ada.Text_IO;

procedure Unbounded_Compile_Time_Calculation is
   F_10 : constant Integer := 10*9*8*7*6*5*4*3*2*1;
   A_11_15 : constant Integer := 15*14*13*12*11;
   A_16_20 : constant Integer := 20*19*18*17*16;
begin
   Ada.Text_IO.Put_Line -- prints out
     ("20 choose 10 =" & Integer'Image((A_11_15 * A_16_20 * F_10) / (F_10 * F_10)));
--   Ada.Text_IO.Put_Line -- would not compile
--     ("Factorial(20) =" & Integer'Image(A_11_15 * A_16_20 * F_10));
end Unbounded_Compile_Time_Calculation;
