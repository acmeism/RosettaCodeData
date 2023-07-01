package body MRG32KA is

   type Data_Array is array (0..2) of I64;

   d : constant I64 := m1 + 1;
   ----------------
   -- Generators --
   ----------------

   a1 : Data_Array := (0, 1403580, -810728);
   a2 : Data_Array := (527612, 0, -1370589);

   x1 : Data_Array := (0, 0, 0);
   x2 : Data_Array := (0, 0, 0);
   ----------
   -- Seed --
   ----------

   procedure Seed (seed_state : state_value) is
   begin
      x1 := (seed_state, 0, 0);
      x2 := (seed_state, 0, 0);
   end Seed;

   --------------
   -- Next_Int --
   --------------

   function Next_Int return I64 is
      x1i : i64;
      x2i : I64;
      z   : I64;
      answer : I64;
   begin
      x1i := (a1(0) * x1(0) + a1(1) * x1(1) + a1(2) * x1(2)) mod m1;
      x2i := (a2(0) * x2(0) + a2(1) * x2(1) + a2(2) * x2(2)) mod m2;
      x1  := (x1i, x1(0), x1(1));
      x2  := (x2i, x2(0), x2(1));
      z := (x1i - x2i) mod m1;
      answer := z + 1;
      return answer;
   end Next_Int;

   ----------------
   -- Next_Float --
   ----------------

   function Next_Float return Long_Float is
   begin
      return Long_float(Next_Int) / Long_Float(d);
   end Next_Float;

end MRG32KA;
