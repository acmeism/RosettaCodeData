package Bonacci is

   type Sequence is array(Positive range <>) of Positive;

   function Generate(Start: Sequence; Length: Positive := 10) return Sequence;

   Start_Fibonacci:  constant Sequence := (1, 1);
   Start_Tribonacci: constant Sequence := (1, 1, 2);
   Start_Tetranacci: constant Sequence := (1, 1, 2, 4);
   Start_Lucas:      constant Sequence := (2, 1);
end Bonacci;
