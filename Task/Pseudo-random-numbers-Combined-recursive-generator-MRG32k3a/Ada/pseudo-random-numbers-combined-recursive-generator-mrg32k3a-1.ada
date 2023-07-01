package MRG32KA is
   type I64 is range -2**63..2**63 - 1;
   m1 : constant I64 := 2**32 - 209;
   m2 : constant I64 := 2**32 - 22853;

   subtype state_value is I64 range 1..m1;

   procedure Seed (seed_state : state_value);
   function Next_Int return I64;
   function Next_Float return Long_Float;
end MRG32KA;
