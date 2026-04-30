package body Multiplicative_Order is

   function Find_Order(Element, Modulus: Positive) return Positive is

      function Power(Exp, Pow, M: Positive) return Positive is
         -- computes Exp**Pow mod M;
         -- note that Ada's native integer exponentiation "**" may overflow on
         -- computing Exp**Pow before ever computing the "mod M" part
         Result: Positive := 1;
         E: Positive := Exp;
         P: Natural := Pow;
      begin
         while P > 0 loop
            if P mod 2 = 1 then
               Result := (Result * E) mod M;
            end if;
            E := (E * E) mod M;
            P := P / 2;
         end loop;
         return Result;
      end Power;

   begin -- Find_Order(Element, Modulus)
      for I in 1 .. Modulus loop
         if Power(Element, I, Modulus) = 1 then
            return Positive(I);
         end if;
      end loop;
      raise Program_Error with
        Positive'Image(Element) &" is not coprime to" &Positive'Image(Modulus);
   end Find_Order;

   function Find_Order(Element: Positive;
                       Coprime_Factors: Positive_Array) return Positive is

         function GCD (A, B : Positive) return Integer is
            M : Natural := A;
            N : Natural := B;
            T : Natural;
         begin
            while N /= 0 loop
               T := M;
               M := N;
               N ;:= T mod N;
            end loop;
            return M;
         end GCD; -- from http://rosettacode.org/wiki/Least_common_multiple#Ada

         function LCM (A, B : Natural) return Integer is
         begin
            if A = 0 or B = 0 then
               return 0;
            end if;
            return abs (A * B) / Gcd (A, B);
         end LCM; -- from http://rosettacode.org/wiki/Least_common_multiple#Ada

         Result : Positive := 1;

   begin -- Find_Order(Element, Coprime_Factors)
      for I in Coprime_Factors'Range loop
         Result := LCM(Result, Find_Order(Element, Coprime_Factors(I)));
      end loop;
      return Result;
   end Find_Order;

end Multiplicative_Order;
