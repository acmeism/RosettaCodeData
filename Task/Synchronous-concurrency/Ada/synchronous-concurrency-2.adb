with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Synchronous_Concurrent is

   task body Printer is
      Num_Iter : Natural := 0;
      Line     : Unbounded_String;
   begin
      loop
         select
            accept Put(Item : in String) do
               Line := To_Unbounded_String(Item);
            end Put;
            Put_Line(To_String(Line));
            Num_Iter := Num_Iter + 1;
         or
            accept Get_Count(Count : out Natural) do
               Count := Num_Iter;
            end Get_Count;
         or terminate;
         end select;
      end loop;
   end Printer;

end Synchronous_Concurrent;
