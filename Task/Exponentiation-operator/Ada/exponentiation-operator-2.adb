with Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
with Integer_Exponentiation;

procedure Test_Integer_Exponentiation is
   use Ada.Float_Text_IO, Ada.Integer_Text_IO, Ada.Text_IO;
   use Integer_Exponentiation;
   R : Float;
   I : Integer;
begin
   Exponentiate (Argument => 2.5, Exponent => 3, Result => R);
   Put ("2.5 ^ 3 = ");
   Put (R, Fore => 2, Aft => 4, Exp => 0);
   New_Line;

   Exponentiate (Argument => -12, Exponent => 3, Result => I);
   Put ("-12 ^ 3 = ");
   Put (I, Width => 7);
   New_Line;
end Test_Integer_Exponentiation;
