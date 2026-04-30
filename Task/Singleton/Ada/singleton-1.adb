package Global_Singleton is
   procedure Set_Data (Value : Integer);
   function Get_Data return Integer;
private
   type Instance_Type is record
      -- Define instance data elements
      Data : Integer := 0;
   end record;
   Instance : Instance_Type;
end Global_Singleton;
