package body LCG is

   State: Base_Type := Base_Type'First;

   procedure Initialize(Seed: Base_Type) is
   begin
      State := Seed;
   end Initialize;

   function Random return Base_Type is
   begin
      State := State * Multiplyer + Adder;
      return State / Output_Divisor;
   end Random;

end LCG;
