-- Rosetta Code Task written in Ada
-- Summation of primes
-- https://rosettacode.org/wiki/Summation_of_primes
-- MacOS, M1, GNAT 15.0.1 20250418 (prerelease)
-- June 2025, R. B. E.

pragma Ada_2022;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers;
use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Summation_of_Primes is

   function Is_Prime (N : in Big_Integer) return Boolean is
      Big_0    : Big_Natural := To_Big_Integer (0);
      Big_2    : Big_Natural := To_Big_Integer (2);
      Big_3    : Big_Natural := To_Big_Integer (3);
      Big_Temp : Big_Natural := To_Big_Integer (5);
   begin
      if N < Big_2 then
         return False;
      end if;
      if N mod Big_2 = Big_0 then
         return N = Big_2;
      end if;
      if N mod Big_3 = Big_0 then
         return N = Big_3;
      end if;
      while Big_Temp * Big_Temp <= N loop
         if N mod Big_Temp = Big_0 then
            return False;
         end if;
         Big_Temp := Big_Temp + Big_2;
         if N mod Big_Temp = Big_0 then
            return False;
         end if;
      end loop;
      return True;
   end Is_Prime;

   Largest_Prime_Candidate : constant Positive := 2_000_000;
   Sum       : Big_Natural := To_Big_Integer (0);
   Candidate : Big_Positive;

begin
   for I in 1 .. Largest_Prime_Candidate loop
      Candidate := To_Big_Integer (I);
      if Is_Prime (Candidate) then
         Sum := Sum + Candidate;
      end if;
   end loop;
   Put ("The sum of all primes less than ");
   Put (Largest_Prime_Candidate, 0);
   Put (" is: ");
   Put (To_String (Arg => Sum, Width => 12));
   New_Line;
end Summation_of_Primes;
