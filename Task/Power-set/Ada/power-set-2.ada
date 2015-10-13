package body Power_Set is

   procedure All_Subsets(S: Set) is

      procedure Visit_Sets(Unmarked: Set; Marked: Set) is
	 Tail: Set      := Unmarked(Unmarked'First+1 .. Unmarked'Last);
      begin
	 if Unmarked = Empty_Set then
	    Visit(Marked);
	 else
	    Visit_Sets(Tail, Marked & Unmarked(Unmarked'First));
	    Visit_Sets(Tail, Marked);
	 end if;
      end Visit_Sets;

   begin
      Visit_Sets(S, Empty_Set);
   end All_Subsets;

end Power_Set;
