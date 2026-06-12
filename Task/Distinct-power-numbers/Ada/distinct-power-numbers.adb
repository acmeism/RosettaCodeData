with Ada.Text_Io;
with Ada.Containers.Doubly_Linked_Lists;

procedure Power_Numbers is

   package Number_Lists   is new Ada.Containers.Doubly_Linked_Lists (Integer);
   package Number_Sorting is new Number_Lists.Generic_Sorting;
   use Number_Lists, Ada.Text_Io;

   List : Number_Lists.List;
begin
   for A in 2 .. 5 loop
      for B in 2 .. 5 loop
         declare
            R : constant Integer := A**B;
         begin
            if not List.Contains (R) then
               List.Append (R);
            end if;
         end;
      end loop;
   end loop;

   Number_Sorting.Sort (List);

   for E of List loop
      Put (Integer'Image (E));
      Put (" ");
   end loop;
   New_Line;

end Power_Numbers;
