with Ada.Containers.Ordered_Sets;
with Ada.Text_IO; use Ada.Text_IO;

procedure Unique_Set is
   package Int_Sets is new Ada.Containers.Ordered_Sets(Integer);
   use Int_Sets;
   Nums : array (Natural range <>) of Integer := (1,2,3,4,5,5,6,7,1);
   Unique : Set;
   Set_Cur : Cursor;
   Success : Boolean;
begin
   for I in Nums'range loop
      Unique.Insert(Nums(I), Set_Cur, Success);
   end loop;
   Set_Cur := Unique.First;
   loop
      Put_Line(Item => Integer'Image(Element(Set_Cur)));
      exit when Set_Cur = Unique.Last;
      Set_Cur := Next(Set_Cur);
   end loop;
end Unique_Set;
