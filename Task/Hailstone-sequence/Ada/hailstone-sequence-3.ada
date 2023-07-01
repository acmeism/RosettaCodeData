package body Hailstones is
   function Create_Sequence (N : Positive) return Integer_Sequence is
   begin
      if N = 1 then
         -- terminate
         return (1 => N);
      elsif N mod 2 = 0 then
         -- even
         return (1 => N) & Create_Sequence (N / 2);
      else
         -- odd
         return (1 => N) & Create_Sequence (3 * N + 1);
      end if;
   end Create_Sequence;
end Hailstones;
