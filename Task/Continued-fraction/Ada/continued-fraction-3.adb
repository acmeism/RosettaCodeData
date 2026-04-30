with Ada.Text_IO;

with Continued_Fraction;

procedure Test_Continued_Fractions is
   type Scalar is digits 15;

   package Square_Root_Of_2 is
      function A (N : in Natural)  return Natural is (if N = 0 then 1 else 2);
      function B (N : in Positive) return Natural is (1);

      function Estimate is new Continued_Fraction (Scalar, A, B);
   end Square_Root_Of_2;

   package Napiers_Constant is
      function A (N : in Natural)  return Natural is (if N = 0 then 2 else N);
      function B (N : in Positive) return Natural is (if N = 1 then 1 else N-1);

      function Estimate is new Continued_Fraction (Scalar, A, B);
   end Napiers_Constant;

   package Pi is
      function A (N : in Natural)  return Natural is  (if N = 0 then 3 else 6);
      function B (N : in Positive) return Natural is ((2 * N - 1) ** 2);

      function Estimate is new Continued_Fraction (Scalar, A, B);
   end Pi;

   package Scalar_Text_IO is new Ada.Text_IO.Float_IO (Scalar);
   use Ada.Text_IO, Scalar_Text_IO;
begin
   Put (Square_Root_Of_2.Estimate (200), Exp => 0); New_Line;
   Put (Napiers_Constant.Estimate (200), Exp => 0); New_Line;
   Put (Pi.Estimate (10000),             Exp => 0); New_Line;
end Test_Continued_Fractions;
