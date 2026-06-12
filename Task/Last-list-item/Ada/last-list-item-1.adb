with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Last_List_Item_Sorted is

   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);

   package Vectors is
     new Ada.Containers.Vectors (Index_Type   => Positive,
                                 Element_Type => Integer);
   package Vector_Sorting is
     new Vectors.Generic_Sorting;
   use Ada.Containers, Vectors, Ada.Text_IO, Integer_IO;

   procedure Put (List : Vector) is
   begin
      Put ("[");
      for V of List loop
         Put (" "); Put (V, Width => 0);
      end loop;
      Put ("]");
   end Put;

   List : Vector := 6 & 81 & 243 & 14 & 25 & 49 & 123 & 69 & 11;

begin
   Default_Width := 0;
   while List.Length >= 2 loop
      Vector_Sorting.Sort (List);
      Put (List);
      declare
         Small_1 : constant Integer := List (List.First_Index + 0);
         Small_2 : constant Integer := List (List.First_Index + 1);
         Sum     : constant Integer := Small_1 + Small_2;
      begin
         List.Delete_First (2);
         Put (". Smallest: ");  Put (Small_1);  Put (" and ");  Put (Small_2);
         Put (". Sum: ");  Put (Sum);  New_Line;
         List.Append (Sum);
      end;
   end loop;
   Put (List); New_Line;
end Last_List_Item_Sorted;
