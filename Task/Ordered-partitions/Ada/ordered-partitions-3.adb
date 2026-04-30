with Ada.Text_IO;
with Partitions;
procedure Main is
   package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);
   Example_Partitions : Partitions.Partition_Sets.Set;
begin
   Ada.Text_IO.Put_Line ("Partitions for (2, 0, 2):");
   -- create partition
   Example_Partitions := Partitions.Create_Partitions (Args => (2, 0, 2));
   -- pretty print the result
   declare
      use type Partitions.Partition_Sets.Cursor;
      Position : Partitions.Partition_Sets.Cursor := Example_Partitions.First;
   begin
      Ada.Text_IO.Put ('{');
      while Position /= Partitions.Partition_Sets.No_Element loop
         if Position /= Example_Partitions.First then
            Ada.Text_IO.Put (' ');
         end if;
         declare
            Current_Partition : constant Partitions.Partition :=
               Partitions.Partition_Sets.Element (Position);
         begin
            Ada.Text_IO.Put ('(');
            for I in Current_Partition'Range loop
               Ada.Text_IO.Put ('{');
               declare
                  use type Partitions.Number_Sets.Cursor;
                  Current_Number : Partitions.Number_Sets.Cursor :=
                     Current_Partition (I).First;
               begin
                  while Current_Number /= Partitions.Number_Sets.No_Element
                  loop
                     Natural_IO.Put
                       (Item  =>
                           Partitions.Number_Sets.Element (Current_Number),
                        Width => 1);
                     Partitions.Number_Sets.Next (Current_Number);
                     if Current_Number /=
                        Partitions.Number_Sets.No_Element then
                        Ada.Text_IO.Put (',');
                     end if;
                  end loop;
               end;
               Ada.Text_IO.Put ('}');
               if I /= Current_Partition'Last then
                  Ada.Text_IO.Put (", ");
               end if;
            end loop;
         end;
         Ada.Text_IO.Put (')');
         Partitions.Partition_Sets.Next (Position);
         if Position /= Partitions.Partition_Sets.No_Element then
            Ada.Text_IO.Put (',');
            Ada.Text_IO.New_Line;
         end if;
      end loop;
      Ada.Text_IO.Put ('}');
      Ada.Text_IO.New_Line;
   end;
end Main;
