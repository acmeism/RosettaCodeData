with Ada.Text_IO;

with Continued_Fraction_Ada95;

procedure Test_Continued_Fractions_Ada95 is
   type Scalar is digits 15;

   package Square_Root_Of_2 is
      function A (N : in Natural)  return Natural;
      function B (N : in Positive) return Natural;

      function Estimate is new Continued_Fraction_Ada95 (Scalar, A, B);
   end Square_Root_Of_2;

   package body Square_Root_Of_2 is
      function A (N : in Natural) return Natural is
      begin
         if N = 0 then
            return 1;
         else
            return 2;
         end if;
      end A;

      function B (N : in Positive) return Natural is
      begin
         return 1;
      end B;
   end Square_Root_Of_2;

   package Napiers_Constant is
      function A (N : in Natural)  return Natural;
      function B (N : in Positive) return Natural;

      function Estimate is new Continued_Fraction_Ada95 (Scalar, A, B);
   end Napiers_Constant;

   package body Napiers_Constant is
      function A (N : in Natural) return Natural is
      begin
         if N = 0 then
            return 2;
         else
            return N;
         end if;
      end A;

      function B (N : in Positive) return Natural is
      begin
          if N = 1 then
             return 1;
          else
             return N - 1;
          end if;
      end B;
   end Napiers_Constant;

   package Pi is
      function A (N : in Natural)  return Natural;
      function B (N : in Positive) return Natural;

      function Estimate is new Continued_Fraction_Ada95 (Scalar, A, B);
   end Pi;

   package body Pi is
      function A (N : in Natural) return Natural is
      begin
         if N = 0 then
            return 3;
         else
            return 6;
         end if;
      end A;

      function B (N : in Positive) return Natural is
      begin
         return (2 * N - 1) ** 2;
      end B;
   end Pi;

   package Scalar_Text_IO is new Ada.Text_IO.Float_IO (Scalar);
   use Ada.Text_IO, Scalar_Text_IO;
begin
   Put (Square_Root_Of_2.Estimate (200), Exp => 0); New_Line;
   Put (Napiers_Constant.Estimate (200), Exp => 0); New_Line;
   Put (Pi.Estimate (10000),             Exp => 0); New_Line;
end Test_Continued_Fractions_Ada95;
