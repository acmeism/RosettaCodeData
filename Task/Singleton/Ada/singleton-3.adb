package Protected_Singleton is
   procedure Set_Data (Value : Integer);
   function Get_Data return Integer;
private
   protected Instance is
      procedure Set(Value : Integer);
      function Get return Integer;
   private
      Data : Integer := 0;
   end Instance_Type;
end Protected_Singleton;
