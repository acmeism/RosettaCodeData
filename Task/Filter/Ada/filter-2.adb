with Ada.Text_IO;  use Ada.Text_IO;

procedure Array_Selection is
   type Array_Type is array (Positive range <>) of Integer;

   function Evens (Item : Array_Type) return Array_Type is
      Result : Array_Type (1..Item'Length);
      Index  : Positive := 1;
   begin
      for I in Item'Range loop
         if Item (I) mod 2 = 0 then
            Result (Index) := Item (I);
            Index := Index + 1;
         end if;
      end loop;
      return Result (1..Index - 1);
   end Evens;

   procedure Put (Item : Array_Type) is
   begin
      for I in Item'range loop
         Put (Integer'Image (Item (I)));
      end loop;
   end Put;
begin
   Put (Evens ((1,2,3,4,5,6,7,8,9,10)));
   New_Line;
end Array_Selection;
