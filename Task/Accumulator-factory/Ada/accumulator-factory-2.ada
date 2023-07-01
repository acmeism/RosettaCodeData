generic package Accumulator is

--  This Ada generic package represents an accumulator factory.
--  The required function is provided as The_Function.
--  The first call to The_Function sets the initial value.
--  (Marius Amado-Alves)

   function The_Function (X : Integer) return Integer;
   function The_Function (X : Integer) return Float;
   function The_Function (X : Float) return Float;
end;
