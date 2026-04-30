package Pythagorean_Means is
   type Set is array (Positive range <>) of Float;
   function Arithmetic_Mean (Data : Set) return Float;
   function Geometric_Mean  (Data : Set) return Float;
   function Harmonic_Mean   (Data : Set) return Float;
end Pythagorean_Means;
