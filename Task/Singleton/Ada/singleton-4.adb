package body Protected_Singleton is

   --------------
   -- Set_Data --
   --------------

   procedure Set_Data (Value : Integer) is
   begin
      Instance.Set(Value);
   end Set_Data;

   --------------
   -- Get_Data --
   --------------

   function Get_Data return Integer is
   begin
      return Instance.Get;
   end Get_Data;

   --------------
   -- Instance --
   --------------

   protected body Instance is

      ---------
      -- Set --
      ---------

      procedure Set (Value : Integer) is
      begin
         Data := Value;
      end Set;

      ---------
      -- Get --
      ---------

      function Get return Integer is
      begin
         return Data;
      end Get;

   end Instance;

end Protected_Singleton;
