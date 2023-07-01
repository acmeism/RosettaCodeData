package body random_pcg32 is

   State : Unsigned_64 := 0;
   inc   : Unsigned_64 := 0;

   ----------------
   -- Next_State --
   ----------------

   procedure Next_State is
      N : constant Unsigned_64 := 6_364_136_223_846_793_005;
   begin
      State := State * N + inc;
   end Next_State;

   --------------
   -- Next_Int --
   --------------

   function Next_Int return Unsigned_32 is
      old     : Unsigned_64          := State;
      shifted : Unsigned_32;
      Rot     : Unsigned_64;
      answer  : Unsigned_32;
      Mask32  : constant Unsigned_64 := Unsigned_64 (Unsigned_32'Last);
   begin
      shifted := Unsigned_32((((old / 2**18) xor old) / 2**27) and Mask32);
      Rot     := old / 2**59;
      answer  :=
        Shift_Right (shifted, Integer (Rot)) or
        Shift_Left (shifted, Integer ((not Rot + 1) and 31));
      Next_State;
      return answer;
   end Next_Int;

   ----------------
   -- Next_Float --
   ----------------

   function Next_Float return Long_Float is
   begin
      return Long_Float (Next_Int) / (2.0**32);
   end Next_Float;

   ----------
   -- Seed --
   ----------

   procedure Seed (seed_state : Unsigned_64; seed_sequence : Unsigned_64) is
   begin
      State := 0;
      inc   := (2 * seed_sequence) or 1;
      Next_State;
      State := State + seed_state;
      Next_State;
   end Seed;

end random_pcg32;
