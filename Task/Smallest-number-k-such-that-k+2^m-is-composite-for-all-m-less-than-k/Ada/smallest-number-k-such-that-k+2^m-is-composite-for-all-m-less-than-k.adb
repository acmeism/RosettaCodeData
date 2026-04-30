-- Rosetta Code Task written in Ada
-- Smallest number k such that k+2^m is composite for all m less than k
-- https://rosettacode.org/wiki/Smallest_number_k_such_that_k%2B2%5Em_is_composite_for_all_m_less_than_k
-- loosely translated from the Python solution
-- uses Unbounded_Unsigneds from Simple Components
-- January 2025, R. B. E. (with significant support from the author of the Simple Components Ada Package)

with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Smallest_k is

   function Is_A033919 (K : Bit_Count) return Boolean is
      N : Unbounded_Unsigned;
   begin
      for M in 1..K loop
         Power_Of_Two (M, N);
         Add (N, Half_Word (K));
         if Is_Prime (N, 15) /= Composite then
            return False;
         end if;
      end loop;
      return True;
   end Is_A033919;

   Numbers_Found : Natural := 0;
   Max_Numbers_to_Calculate : constant Positive := 5;
   I : Bit_Count := 3;
begin
   loop
      if Is_A033919 (I) then
         Numbers_Found := Numbers_Found + 1;
         Put (Bit_Count'Image (I));
      end if;
      exit when Numbers_Found = Max_Numbers_to_Calculate;
      I := I + 2;
   end loop;
   New_Line;
end Smallest_k;
