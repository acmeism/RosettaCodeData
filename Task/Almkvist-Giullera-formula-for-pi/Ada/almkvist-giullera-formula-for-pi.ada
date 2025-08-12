-- Big_Reals is an Ada 2022 unit
with Ada.Numerics.Big_Numbers.Big_Reals;
with Ada.Text_IO;

use Ada.Numerics.Big_Numbers.Big_Reals;

procedure Almkvist_Giullera is

   function "+" (B : Big_Real; A : Integer) return Big_Real is (B + To_Real (A));
   function "*" (A : Integer; B : Big_Real) return Big_Real is (To_Real (A) * B);
   B0 : constant Big_Real := To_Real (0);
   B1 : constant Big_Real := B0 + 1;

   function Factorial (N : Big_Real) return Big_Real
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
   procedure Put_Line (S : String) renames Ada.Text_IO.Put_Line;

   function Integer_Term (N : Big_Real) return Big_Real is
     (32 * F (6 * N) / (3 * F (N) ** 6) * (532 * N ** 2 + 126 * N + 9));

   procedure Show_Integer_Terms (N : Positive) is
   begin
      for I in 0 .. N - 1 loop
         Put_Line ("Almkvist-Giullera integer term "
                   & I'Image & " is "
                   & To_String (Integer_Term (To_Real (I)), Aft => 0));
      end loop;
   end Show_Integer_Terms;

   -- Use Newton's Method
   function Sqrt (N : Big_Real; Precision : Positive) return Big_Real is
      Diff : Big_Real := To_Real (10) ** (-Precision);
      Estimate : Big_Real := B0;
      Next : Big_Real := N;
   begin
      while abs (Next - Estimate) > Diff loop
         Estimate := Next;
         Next := Estimate - (Estimate ** 2 - N) / (2 * Estimate);
         -- Nasty hack to limit precision. Otherwise there is a storage error.
         Next := From_String (To_String (Next, Aft => Precision + 2));
      end loop;

      return Estimate;
   end Sqrt;

   function Estimate_Pi (N : Integer; Precision : Positive) return Big_Real is
      Sum : Big_Real := B0;
   begin
      for I in 0 .. N loop
         Sum := Sum + Integer_Term (To_Real (I)) / To_Real (10) ** (6 * I + 3);
         Sum := From_String (To_String (Sum, Aft => Precision + 2));
      end loop;

      return B1 / Sqrt (Sum, Precision + 2);
   end Estimate_Pi;

   function Compute_Pi (Precision : Positive) return Big_Real is
      Diff : constant Big_Real := To_Real (10) ** (-Precision);
      Pi_Estimate : Big_Real := B0;
      Next : Big_Real := B1;
      N : Integer := 1;
   begin
      while abs (Next - Pi_Estimate) > Diff loop
         N := N * 2;
         Pi_Estimate := Next;
         Next := Estimate_Pi (N, Precision);
      end loop;

      return Pi_Estimate;
   end Compute_Pi;

   procedure Show_Pi (Precision : Positive) is
      Pi : constant Big_Real := Compute_Pi (Precision);
   begin
      Put_Line ("Pi to " & Precision'Image & " places is "
                & To_String (Pi, Aft => Precision));
   end Show_Pi;

begin
   Show_Integer_Terms (10);
   Show_Pi (70);
end almkvist_giullera;
