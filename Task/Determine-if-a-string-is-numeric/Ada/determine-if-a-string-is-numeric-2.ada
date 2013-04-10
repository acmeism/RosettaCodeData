package body Numeric_Tests is
   function Is_Numeric (Item : in String) return Boolean is
      Dummy : Float;
   begin
      Dummy := Float'Value (Item);
      return True;
   exception
      when others =>
         return False;
   end Is_Numeric;
end Numeric_Tests;
