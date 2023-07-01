with Ada.Text_IO;  use Ada.Text_IO;

with Generic_Taylor_Series;
with Generic_Rational;

procedure Test_Taylor_Series is
   package Integer_Rationals is new Generic_Rational (Integer);
   package Integer_Taylor_Series is new Generic_Taylor_Series (Integer_Rationals);
   use Integer_Taylor_Series;
      -- Procedure to print a series
   procedure Put (A : Taylor_Series) is
      use Integer_Rationals;
      procedure Put (A : Rational) is
      begin
         if Numerator (A) = 1 then
            Put (" 1");
         else
            Put (Integer'Image (Numerator (A)));
         end if;
         if Denominator (A) /= 1 then
            Put (" /");
            Put (Integer'Image (Denominator (A)));
         end if;
      end Put;
   begin
      if A (0) /= 0 then
         Put (A (0));
      end if;
      for Power in 1..A'Last loop
         if A (Power) > 0 then
            Put (" +");
            Put (A (Power));
            Put (" X **" & Integer'Image (Power));
         elsif A (Power) < 0 then
            Put (" -");
            Put (abs A (Power));
            Put (" X **" & Integer'Image (Power));
         end if;
      end loop;
   end Put;
      -- Cosine generator
   function Cos (N : Natural) return Taylor_Series is
   begin
      if N = 0 then
         return One;
      else
         return One - Integral (Integral (Cos (N - 1)));
      end if;
   end Cos;
begin
   Put ("Cos ="); Put (Cos (5)); Put_Line (" ...");
   Put ("Sin ="); Put (Integral (Cos (5))); Put_Line (" ...");
end Test_Taylor_Series;
