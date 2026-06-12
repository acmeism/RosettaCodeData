with Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Last_List_Item is

   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);

   package Element_Vectors is
     new Ada.Containers.Vectors (Index_Type   => Positive,
                                 Element_Type => Integer);
   use Ada.Containers, Element_Vectors, Ada.Text_IO, Integer_IO;

   function Pick_Smallest (List : in out Vector) return Integer is
      Value : Integer := Integer'Last;
   begin
      if List.Is_Empty then
         raise Constraint_Error;
      end if;

      for V of List loop
         Value := Integer'Min (Value, V);
      end loop;
      List.Delete (List.Find_Index (Value));
      return Value;
   end Pick_Smallest;

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
      Put (List); Put (". Smallest: ");
      declare
         Small_1 : constant Integer := Pick_Smallest (List);
         Small_2 : constant Integer := Pick_Smallest (List);
         Sum     : constant Integer := Small_1 + Small_2;
      begin
         Put (Small_1);  Put (" and ");  Put (Small_2);
         Put (". Sum: ");  Put (Sum);  New_Line;

         List.Append (Sum);
      end;
   end loop;
   Put (List); New_Line;
end Last_List_Item;
