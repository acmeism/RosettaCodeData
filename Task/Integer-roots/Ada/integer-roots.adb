-- Find integer roots
-- J. Carter     2023 Jun

with Ada.Text_IO;
with System;

procedure Integer_Roots is
   type Big is mod System.Max_Binary_Modulus;

   function Root (N : in Positive; X : in Big) return Big With Pre => N > 1;
   -- Returns the largest integer R such that R ** N <= X
   -- Derived from Modula-2

   function Root (N : in Positive; X : in Big) return Big is
      N1 : constant Positive := N - 1;
      N2 : constant Big      := Big (N);
      N3 : constant Big      := N2 - 1;

      C : Big := 1;
      D : Big := (N3 + X) / N2;
      E : Big := (N3 * D + X / D ** N1) / N2;
   begin -- Root
      if X <= 1 then
         return X;
      end if;

      Converge : loop
         exit Converge when C = D or C = E;

         C := D;
         D := E;
         E := (N3 * D + X / E ** N1) / N2;
      end loop Converge;

      return (if D < E then D else E);
   end Root;

   Large : constant Big := 2 * 10 ** 38;
   -- On 64-bit platforms, recent versions of GNAT provide 128-bit integers
   -- 10 ** 38 is the largest power of 10 < 2 ** 128
begin -- Integer_Roots
   Ada.Text_IO.Put_Line (Item => "Cube root of 8 =" & Root (3, 8)'Image);
   Ada.Text_IO.Put_Line (Item => "Cube root of 9 =" & Root (3, 9)'Image);
   Ada.Text_IO.Put_Line (Item => "Square root of" & Large'Image & " =" & Root (2, Large)'Image);
end Integer_Roots;
