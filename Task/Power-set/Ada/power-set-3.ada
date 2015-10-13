with Ada.Text_IO, Ada.Command_Line, Power_Set;

procedure Print_Power_Set is

   procedure Print_Set(Items: Power_Set.Set) is
      First: Boolean := True;
   begin
      Ada.Text_IO.Put("{ ");
      for Item of Items loop
	 if First then
	    First := False; -- no comma needed
	 else
	    Ada.Text_IO.Put(", "); -- comma, to separate the items
	 end if;
	 Ada.Text_IO.Put(Ada.Command_Line.Argument(Item));
      end loop;
      Ada.Text_IO.Put_Line(" }");
   end Print_Set;

   procedure Print_All_Subsets is new Power_Set.All_Subsets(Print_Set);

   Set: Power_Set.Set(1 .. Ada.Command_Line.Argument_Count);
begin
   for I in Set'Range loop -- initialize set
      Set(I) := I;
   end loop;
   Print_All_Subsets(Set); -- do the work
end;
