package body Global_Singleton is

   --------------
   -- Set_Data --
   --------------

   procedure Set_Data (Value : Integer) is
   begin
      Instance.Data := Value;
   end Set_Data;

   --------------
   -- Get_Data --
   --------------

   function Get_Data return Integer is
   begin
      return Instance.Data;
   end Get_Data;

end Global_Singleton;
