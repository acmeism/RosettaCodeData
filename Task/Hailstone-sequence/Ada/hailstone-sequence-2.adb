package Hailstones is
   type Integer_Sequence is array(Positive range <>) of Integer;
   function Create_Sequence (N : Positive) return Integer_Sequence;
end Hailstones;
