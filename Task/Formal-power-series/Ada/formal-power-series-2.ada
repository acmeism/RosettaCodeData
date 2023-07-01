package body Generic_Taylor_Series is
   function Normalize (A : Taylor_Series) return Taylor_Series is
   begin
      for Power in reverse A'Range loop
         if A (Power) /= 0 then
            return A (0..Power);
         end if;
      end loop;
      return Zero;
   end Normalize;

   function "+" (A : Taylor_Series) return Taylor_Series is
   begin
      return A;
   end "+";

   function "-" (A : Taylor_Series) return Taylor_Series is
      Result : Taylor_Series (A'Range);
   begin
      for Power in A'Range loop
         Result (Power) := -A (Power);
      end loop;
      return Result;
   end "-";

   function "+" (A, B : Taylor_Series) return Taylor_Series is
   begin
      if A'Last > B'Last then
         return B + A;
      else
         declare
            Result : Taylor_Series (0..B'Last);
         begin
            for Power in A'Range loop
               Result (Power) := A (Power) + B (Power);
            end loop;
            for Power in A'Last + 1..B'Last loop
               Result (Power) := B (Power);
            end loop;
            return Normalize (Result);
         end;
      end if;
   end "+";

   function "-" (A, B : Taylor_Series) return Taylor_Series is
   begin
      return A + (-B);
   end "-";

   function "*" (A, B : Taylor_Series) return Taylor_Series is
      Result : Taylor_Series (0..A'Last + B'Last);
   begin
      for I in A'Range loop
         for J in B'Range loop
            Result (I + J) := A (I) * B (J);
         end loop;
      end loop;
      return Normalize (Result);
   end "*";

   function Integral (A : Taylor_Series) return Taylor_Series is
   begin
      if A = Zero then
         return Zero;
      else
         declare
            Result : Taylor_Series (0..A'Last + 1);
         begin
            for Power in A'Range loop
               Result (Power + 1) := A (Power) / Number (Power + 1);
            end loop;
            Result (0) := Rational_Numbers.Zero;
            return Result;
         end;
      end if;
   end Integral;

   function Differential (A : Taylor_Series) return Taylor_Series is
   begin
      if A'Length = 1 then
         return Zero;
      else
         declare
            Result : Taylor_Series (0..A'Last - 1);
         begin
            for Power in Result'Range loop
               Result (Power) := A (Power + 1) * Number (Power);
            end loop;
            return Result;
         end;
      end if;
   end Differential;

   function Value (A : Taylor_Series; X : Rational) return Rational is
      Sum : Rational := A (A'Last);
   begin
      for Power in reverse 0..A'Last - 1 loop
         Sum := Sum * X + A (Power);
      end loop;
      return Sum;
   end Value;

end Generic_Taylor_Series;
