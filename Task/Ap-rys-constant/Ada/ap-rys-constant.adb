-- Big_Reals is an Ada 2022 unit
with Ada.Numerics.Big_Numbers.Big_Reals;
with Ada.Text_IO;

use Ada.Numerics.Big_Numbers.Big_Reals;

procedure Aperys_Constant is
   Aperys_Constant : constant Big_Real := From_String ("1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581");
   B0 : constant Big_Real := To_Real (0);
   B1 : constant Big_Real := To_Real (1);
   B2 : constant Big_Real := To_Real (2);
   B3 : constant Big_Real := To_Real (3);
   B4 : constant Big_Real := To_Real (4);
   B5 : constant Big_Real := To_Real (5);
   B6 : constant Big_Real := To_Real (6);

   function Basic_Zeta_3 (N : Positive) return Big_Real is
      Sum : Big_Real := B0;
      K : Big_Real;
   begin
      for I in 1 .. N loop
         K := To_Real (I);
         Sum := Sum + B1 / K ** 3;
      end loop;

      return Sum;
   end Basic_Zeta_3;

   function Factorial (N : Big_Real) return Big_Real
     with Pre => N >= B0
   is
      I : Big_Real := N;
      F : Big_Real := B1;
   begin
      while I > B1 loop
         F := F * I;
         I := I - B1;
      end loop;

      return F;
   end Factorial;

   function F (N : Big_Real) return Big_Real renames Factorial;

   function Markov_Zeta_3 (N : Positive) return Big_Real is
      Sum : Big_Real := B0;
      K : Big_Real;
   begin
      for I in 1 .. N loop
         K := To_Real (I);
         Sum := Sum + (-B1) ** (I - 1) * F (K) ** 2 / (F (B2 * K) * K ** 3);
      end loop;

      return Sum * B5 / B2;
   end Markov_Zeta_3;

   function Wedeniwski_Zeta_3 (N : Positive) return Big_Real is
      Sum : Big_Real := B0;
      K : Big_Real;
      B_24 : Big_Real := B1 / (B4 * B6);
      B126392 : Big_Real := To_Real (126392);
      B412708 : Big_Real := To_Real (412708);
      B531578 : Big_Real := To_Real (531578);
      B336367 : Big_Real := To_Real (336367);
      B104000 : Big_Real := To_Real (104000);
      B12463 : Big_Real := To_Real (12463);
      Poly : Big_Real;
      Num : Big_Real;
      Den : Big_Real;
   begin
      for I in 0 .. N loop
         K := To_Real (I);
         Poly := B126392 * K ** 5 + B412708 * K ** 4 + B531578 * K ** 3
                 + B336367 * K ** 2 + B104000 * K + B12463;
         Num := Poly * F (B2 * K + B1) ** 3 * F (B2 * K) ** 3 * F (K) ** 3;
         Den := F (B3 * K + B2) * F (B4 * K + B3) ** 3;
         Sum := Sum + (-B1) ** I * Num / Den;
      end loop;

      return Sum * B_24;
   end Wedeniwski_Zeta_3;
begin
   Ada.Text_IO.Put_Line ("Actual:     " & To_String (Aperys_Constant, Aft => 100));
   Ada.Text_IO.Put_Line ("Zeta:       " & To_String (Basic_Zeta_3 (1000), Aft => 100));
   Ada.Text_IO.Put_Line ("Markov:     " & To_String (Markov_Zeta_3 (158), Aft => 100));
   Ada.Text_IO.Put_Line ("Wedeniwski: " & To_String (Wedeniwski_Zeta_3 (20), Aft => 100));
end Aperys_Constant;
