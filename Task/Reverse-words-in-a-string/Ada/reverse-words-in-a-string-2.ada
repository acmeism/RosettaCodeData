package body Simple_Parse is

   function Next_Word(S: String; Point: in out Positive) return String is
      Start: Positive := Point;
      Stop: Natural;
   begin
      while Start <= S'Last and then S(Start) = ' ' loop
	 Start := Start + 1;
      end loop; -- now S(Start) is the first non-space,
		-- or Start = S'Last+1 if S is empty or space-only
      Stop := Start-1; -- now S(Start .. Stop) = ""
      while Stop < S'Last and then S(Stop+1) /= ' ' loop
	 Stop := Stop + 1;
      end loop; -- now S(Stop+1) is the first sopace after Start
		-- or Stop = S'Last if there is no such space
      Point := Stop+1;
      return S(Start .. Stop);
   end Next_Word;

end Simple_Parse;
