with Ada.Text_IO;          use Ada.Text_IO;
with Unbounded_Integers;   use Unbounded_Integers;
with Unbounded_Rationals;  use Unbounded_Rationals;

with Strings_Edit.Unbounded_Integer_Edit;
use  Strings_Edit.Unbounded_Integer_Edit;

with Strings_Edit.Unbounded_Rational_Edit;
use  Strings_Edit.Unbounded_Rational_Edit;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Metallic_Ratios is
   procedure Metallic (B, P, First : Natural) is
      Eps   : Unbounded_Rational := To_Unbounded_Rational (10)**(-P-1);
      X0    : Unbounded_Integer  := To_Unbounded_Integer (1);
      X1    : Unbounded_Integer  := To_Unbounded_Integer (1);
      R0    : Unbounded_Rational;
      R1    : Unbounded_Rational;
      Count : Natural := 0;
   begin
      Put ("B:" & Integer'Image (B) & " | 1 1");
      for I in Positive'Range loop
         X0 := X1 * B + X0;
         Swap (X1, X0);
         if I <= First then
            Put (" " & Image (X1));
         end if;
         R0 := To_Unbounded_Rational (X1) / X0;
         if abs (R1 - R0) <= Eps then
            exit when I > First;
         else
            Count := Count + 1;
         end if;
         Swap (R0, R1);
      end loop;
      New_Line;
      Put_Line
      (  Image (R1, Fraction => P)
      &  " after" & Integer'Image (Count)
      );
   end Metallic;
begin
   for B in 0..9 loop
      Metallic (B, 32, 15);
   end loop;
   New_Line;
   Metallic (1, 256, 15);
end Metallic_Ratios;
