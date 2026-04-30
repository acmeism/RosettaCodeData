generic
   type Base_Type is mod <>;
   Multiplyer, Adder: Base_Type;
   Output_Divisor: Base_Type := 1;
package LCG is

   procedure Initialize(Seed: Base_Type);
   function Random return Base_Type;
   -- changes the state and outputs the result

end LCG;
