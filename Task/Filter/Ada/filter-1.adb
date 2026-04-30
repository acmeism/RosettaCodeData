with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;

procedure Array_Selection is
   type Array_Type is array (Positive range <>) of Integer;
   Null_Array : Array_Type(1..0);

   function Evens (Item : Array_Type) return Array_Type is
   begin
      if Item'Length > 0 then
         if Item(Item'First) mod 2 = 0 then
            return Item(Item'First) & Evens(Item((Item'First + 1)..Item'Last));
         else
            return Evens(Item((Item'First + 1)..Item'Last));
         end if;
      else
         return Null_Array;
      end if;
   end Evens;

   procedure Print(Item : Array_Type) is
   begin
      for I in Item'range loop
         Put(Item(I));
         New_Line;
      end loop;
   end Print;

   Foo : Array_Type := (1,2,3,4,5,6,7,8,9,10);
begin
   Print(Evens(Foo));
end Array_Selection;
