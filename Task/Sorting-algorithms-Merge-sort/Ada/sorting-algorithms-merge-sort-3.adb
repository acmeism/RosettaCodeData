with Ada.Text_Io; use Ada.Text_Io;
with Mergesort;

procedure Mergesort_Test is
   type List_Type is array(Positive range <>) of Integer;
   package List_Sort is new Mergesort(Integer, Positive, List_Type);
   procedure Print(Item : List_Type) is
   begin
      for I in Item'range loop
         Put(Integer'Image(Item(I)));
      end loop;
      New_Line;
   end Print;

   List : List_Type := (1, 5, 2, 7, 3, 9, 4, 6);
begin
   Print(List);
   Print(List_Sort.Sort(List));
end Mergesort_Test;
