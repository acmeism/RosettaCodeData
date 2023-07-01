with Ada.Text_IO; use Ada.Text_IO;

procedure Antiprimes is

   function Count_Divisors (N : Integer) return Integer is
      Count : Integer := 1;
   begin
      for i in 1 .. N / 2 loop
         if N mod i = 0 then
            Count := Count + 1;
         end if;
      end loop;
      return Count;
   end Count_Divisors;

   Results      : array (1 .. 20) of Integer;
   Candidate    : Integer := 1;
   Divisors     : Integer;
   Max_Divisors : Integer := 0;

begin
   for i in Results'Range loop
      loop
         Divisors := Count_Divisors (Candidate);
         if Max_Divisors < Divisors then
            Results (i)  := Candidate;
            Max_Divisors := Divisors;
            exit;
         end if;
         Candidate := Candidate + 1;
      end loop;
   end loop;
   Put_Line ("The first 20 anti-primes are:");
   for I in Results'Range loop
      Put (Integer'Image (Results (I)));
   end loop;
   New_Line;
end Antiprimes;
