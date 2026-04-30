with Ada.Text_IO;            use Ada.Text_IO;
with Strings_Edit;           use Strings_Edit;
with Strings_Edit.Integers;  use Strings_Edit.Integers;
with Unbounded_Rationals;    use Unbounded_Rationals;
with Unbounded_Unsigneds;    use Unbounded_Unsigneds;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Bernoulli is
   function Bernoulli_Number (N : Natural) return Unbounded_Rational is
      A : array (0..Half_Word (N)) of Unbounded_Rational;
   begin
      for M in 0..Half_Word (N) loop
         A (M) := Unbounded_Rationals.One / (M + 1);
         for J in reverse 1..M LOOP
            A (J - 1) := J * (A (J - 1) - A (J));
         end loop;
      end loop;
      return A (0);
   end Bernoulli_Number;
   B       : Unbounded_Rational;
   Line    : String (1..80);
   Pointer : Integer;
begin
   for I in 0..60 loop
      if I mod 2 = 0 or else I = 1 then
         B := Bernoulli_Number (I);
         if not Is_Zero (B) then
            Pointer := 1;
            Put (Line, Pointer, "B(");
            Put (Line, Pointer, I, 10, False, 2, Right);
            Put (Line, Pointer, ") = ");
            if Is_Negative (B) then
               Put (Line, Pointer, '-' & Image (Get_Numerator (B)), 45, Right);
            else
               Put (Line, Pointer, Get_Numerator (B), 10, 45, Right);
            end if;
            Put (Line, Pointer, " / ");
            Put (Line, Pointer, Get_Denominator (B));
            Put_Line (Line (1..Pointer - 1));
         end if;
      end if;
   end loop;
end Bernoulli;
