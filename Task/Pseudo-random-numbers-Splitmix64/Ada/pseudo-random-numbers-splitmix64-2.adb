package body Random_Splitmix64 is
   Internal : Unsigned_64 := 1234567;

   --------------
   -- next_Int --
   --------------

   function next_Int return Unsigned_64 is
      Z : Unsigned_64;
   begin
      Internal := Internal + 16#9e3779b97f4a7c15#;
      Z := Internal;
      Z := (Z xor Shift_Right(Z, 30)) * 16#bf58476d1ce4e5b9#;
      Z := (Z xor Shift_Right(Z, 27)) * 16#94d049bb133111eb#;
      return Z xor Shift_Right(Z, 31);
   end next_Int;

   ----------------
   -- next_float --
   ----------------

   function next_float return Float is
   begin
      return float(next_int) / (2.0 ** 64);
   end next_float;

   ---------------
   -- Set_State --
   ---------------

   procedure Set_State (Seed : in Unsigned_64) is
   begin
      Internal := Seed;
   end Set_State;

end Random_Splitmix64;
