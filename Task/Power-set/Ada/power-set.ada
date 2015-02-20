with Ada.Text_IO, Ada.Command_Line;

procedure Power_Set is

   type List is array  (Positive range <>) of Positive;
   Empty: List(1 .. 0);

   procedure Print_All_Subsets(Set: List; Printable: List:= Empty) is
	
      procedure Print_Set(Items: List) is
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

      Tail: List := Set(Set'First+1 .. Set'Last);

   begin
      if Set = Empty then
	 Print_Set(Printable);
      else
	 Print_All_Subsets(Tail, Printable & Set(Set'First));
	 Print_All_Subsets(Tail, Printable);
      end if;
   end Print_All_Subsets;

   Set: List(1 .. Ada.Command_Line.Argument_Count);
begin
   for I in Set'Range loop -- initialize set
      Set(I) := I;
   end loop;
   Print_All_Subsets(Set); -- do the work
end Power_Set;
