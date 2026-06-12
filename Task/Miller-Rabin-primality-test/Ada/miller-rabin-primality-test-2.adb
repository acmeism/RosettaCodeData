with Ada.Numerics.Discrete_Random;

package body Miller_Rabin is

   function Is_Prime (N : Number; K : Positive := 10)
                     return Result_Type
   is
      subtype Number_Range is Number range 2 .. N - 1;
      package Random is new Ada.Numerics.Discrete_Random (Number_Range);

      function Mod_Exp (Base, Exponent, Modulus : Number) return Number is
         Result : Number := 1;
      begin
         for E in 1 .. Exponent loop
            Result := Result * Base mod Modulus;
         end loop;
         return Result;
      end Mod_Exp;

      Generator : Random.Generator;
      D : Number := N - 1;
      S : Natural := 0;
      X : Number;
   begin
      -- exclude 2 and even numbers
      if N = 2 then
         return Probably_Prime;
      elsif N mod 2 = 0 then
         return Composite;
      end if;

      -- write N-1 as 2**S * D, with D mod 2 /= 0
      while D mod 2 = 0 loop
         D := D / 2;
         S := S + 1;
      end loop;

      -- initialize RNG
      Random.Reset (Generator);
      for Loops in 1 .. K loop
         X := Mod_Exp(Random.Random (Generator), D, N);
         if X /= 1 and X /= N - 1 then
        Inner : for R in 1 .. S - 1 loop
               X := Mod_Exp (X, 2, N);
               if X = 1 then return Composite; end if;
               exit Inner when X = N - 1;
            end loop Inner;
            if X /= N - 1 then return Composite; end if;
         end if;
      end loop;

      return Probably_Prime;
   end Is_Prime;

end Miller_Rabin;
