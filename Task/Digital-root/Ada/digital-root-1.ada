package Generic_Root is
   type Number is range 0 .. 2**63-1;
   type Number_Array is array(Positive range <>) of Number;
   type Base_Type is range 2 .. 16; -- any reasonable base to write down numb

   generic
      with function "&"(X, Y: Number) return Number;
      -- instantiate with "+" for additive digital roots
      -- instantiate with "*" for multiplicative digital roots
   procedure Compute_Root(N: Number;
                     Root, Persistence: out Number;
                     Base: Base_Type := 10);
   -- computes Root and Persistence of N;

end Generic_Root;
