 with Ada.Numerics.Discrete_Random;

package body Random_57 is
   type M5 is mod 5;

   package Rand_5 is new  Ada.Numerics.Discrete_Random(M5);
   Gen: Rand_5.Generator;
      function Random7 return Mod_7 is
      N: Natural;

   begin
      loop
         N :=  Integer(Rand_5.Random(Gen))* 5 + Integer(Rand_5.Random(Gen));
         -- N is uniformly distributed in 0 .. 24
         if N < 21 then
            return Mod_7(N/3);
         else -- (N-21) is in 0 .. 3
            N := (N-21) * 5 +  Integer(Rand_5.Random(Gen)); -- N is in 0 .. 19
            if N < 14 then
               return Mod_7(N / 2);
            else -- (N-14) is in 0 .. 5
               N := (N-14) * 5 +  Integer(Rand_5.Random(Gen)); -- N is in 0 .. 29
               if N < 28 then
                  return Mod_7(N/4);
               else -- (N-28) is in 0 .. 1
                  N := (N-28) * 5 + Integer(Rand_5.Random(Gen)); -- 0 .. 9
                  if N < 7 then
                     return Mod_7(N);
                  else -- (N-7) is in 0, 1, 2
                     N := (N-7)* 5 + Integer(Rand_5.Random(Gen)); -- 0 .. 14
                     if N < 14 then
                        return Mod_7(N/2);
                     else -- (N-14) is 0. This is not useful for us!
                        null;
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end loop;

   end Random7;

   function Simple_Random7 return Mod_7 is
      N: Natural :=
        Integer(Rand_5.Random(Gen))* 5 + Integer(Rand_5.Random(Gen));
      -- N is uniformly distributed in 0 .. 24
   begin
      while N > 20 loop
         N :=  Integer(Rand_5.Random(Gen))* 5 + Integer(Rand_5.Random(Gen));
      end loop; -- Now I <= 20
      return Mod_7(N / 3);
   end Simple_Random7;

begin
   Rand_5.Reset(Gen);
end Random_57;
