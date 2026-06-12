with Ada.Text_IO, Crypto.Types.Big_Numbers, Ada.Numerics.Discrete_Random;

procedure Miller_Rabin is

   Bound: constant Positive := 256; -- can be any multiple of 32

   package LN is new Crypto.Types.Big_Numbers (Bound);
   use type LN.Big_Unsigned; -- all computations "mod 2**Bound"

   function "+"(S: String) return LN.Big_Unsigned
     renames LN.Utils.To_Big_Unsigned;

   function Is_Prime (N : LN.Big_Unsigned; K : Positive := 10) return Boolean is

      subtype Mod_32 is Crypto.Types.Mod_Type;
      use type Mod_32;
      package R_32 is new Ada.Numerics.Discrete_Random (Mod_32);
      Generator : R_32.Generator;

      function Random return LN.Big_Unsigned is
         X: LN.Big_Unsigned := LN.Big_Unsigned_Zero;
      begin
         for I in 1 .. Bound/32 loop
            X := (X * 2**16) * 2**16;
            X := X + R_32.Random(Generator);
         end loop;
         return X;
      end Random;

      D:    LN.Big_Unsigned := N - LN.Big_Unsigned_One;
      S:    Natural := 0;
      A, X: LN.Big_Unsigned;
   begin
      -- exclude 2 and even numbers
      if N = 2 then
         return True;
      elsif N mod 2 = LN.Big_Unsigned_Zero then
         return False;
      else

         -- write N-1 as 2**S * D, with odd D
         while D mod 2 = LN.Big_Unsigned_Zero loop
            D := D / 2;
            S := S + 1;
         end loop;

         -- initialize RNG
         R_32.Reset (Generator);

         -- run the real test
         for Loops in 1 .. K loop
            loop
               A := Random;
               exit when (A > 1) and (A < (N - 1));
            end loop;
            X := LN.Mod_Utils.Pow(A, D, N); -- X := (Random**D) mod N
            if X /= 1 and X /= N - 1 then
               Inner:
               for R in 1 .. S - 1 loop
                  X := LN.Mod_Utils.Pow(X, LN.Big_Unsigned_Two, N);
                  if X = 1 then
                     return False;
                  end if;
                  exit Inner when X = N - 1;
               end loop Inner;
               if X /= N - 1 then
                  return False;
               end if;
            end if;
         end loop;
      end if;

      return True;
   end Is_Prime;

   S: constant String :=
     "4547337172376300111955330758342147474062293202868155909489";
   T: constant String :=
     "4547337172376300111955330758342147474062293202868155909393";

   K: constant Positive := 10;

begin
   Ada.Text_IO.Put_Line("Prime(" & S & ")=" & Boolean'Image(Is_Prime(+S, K)));
   Ada.Text_IO.Put_Line("Prime(" & T & ")=" & Boolean'Image(Is_Prime(+T, K)));
end Miller_Rabin;
