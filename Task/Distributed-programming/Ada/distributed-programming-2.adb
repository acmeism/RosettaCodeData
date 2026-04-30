package body Server is
   Count : Natural := 0;

   procedure Foo is
   begin
      Count := Count + 1;
   end Foo;

   function Bar return Natural is
   begin
      return Count;
   end Bar;
end Server;
