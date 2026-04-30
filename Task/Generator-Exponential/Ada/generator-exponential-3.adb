package body Generator is

   --------------
   -- Identity --
   --------------

   function Identity (X : Natural) return Natural is
   begin
      return X;
   end Identity;

   ----------
   -- Skip --
   ----------

   procedure Skip (Gen : access Generator'Class; Count : Positive := 1) is
      Val : Natural;
      pragma Unreferenced (Val);
   begin
      for I in 1 .. Count loop
         Val := Gen.Get_Next;
      end loop;
   end Skip;

   -----------
   -- Reset --
   -----------

   procedure Reset (Gen : in out Generator) is
   begin
      Gen.Last_Source := 0;
      Gen.Last_Value := 0;
   end Reset;

   --------------
   -- Get_Next --
   --------------

   function Get_Next (Gen : access Generator) return Natural is
   begin
      Gen.Last_Source := Gen.Last_Source + 1;
      Gen.Last_Value := Gen.Gen_Func (Gen.Last_Source);
      return Gen.Last_Value;
   end Get_Next;

   ----------------------------
   -- Set_Generator_Function --
   ----------------------------

   procedure Set_Generator_Function
     (Gen  : in out Generator;
      Func : Generator_Function)
   is
   begin
      if Func = null then
         Gen.Gen_Func := Identity'Access;
      else
         Gen.Gen_Func := Func;
      end if;
   end Set_Generator_Function;

end Generator;
