package body Subtractive_Generator is

   procedure Initialize (Generator : in out State; Seed : Natural) is
      S : Number_Array (0 .. 1);
      I : Natural := 0;
      J : Natural := 1;
   begin
      S (0) := Seed;
      S (1) := 1;
      Generator.R (54) := S (0);
      Generator.R (33) := S (1);
      for N in 2 .. Generator.R'Last loop
         S (I) := (S (I) - S (J)) mod 10 ** 9;
         Generator.R ((34 * N - 1) mod 55) := S (I);
         I := (I + 1) mod 2;
         J := (J + 1) mod 2;
      end loop;
      Generator.Last := 54;
      for I in 1 .. 165 loop
         Subtractive_Generator.Next (Generator => Generator, N => J);
      end loop;
   end Initialize;

   procedure Next (Generator : in out State; N : out Natural) is
   begin
      Generator.Last := (Generator.Last + 1) mod 55;
      Generator.R (Generator.Last) :=
        (Generator.R (Generator.Last)
         - Generator.R ((Generator.Last - 24) mod 55)) mod 10 ** 9;
      N := Generator.R (Generator.Last);
   end Next;

end Subtractive_Generator;
