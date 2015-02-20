with Ada.Text_IO, Ada.Strings.Equal_Case_Insensitive;

procedure String_Compare is

   procedure Print_Comparison (A, B: String) is
      use Ada.Text_IO;
      Function eq(Left, Right : String) return Boolean
               renames Ada.Strings.Equal_Case_Insensitive;
   begin
      Put_Line
	( """" & A & """ and """ & B & """: " &
	 (if A =  B then "equal, " elsif eq(A,B)
	    then "case-insensitive-equal, " else "not equal at all, ") &
	 (if A /= B then "/=, " else "") &
	 (if A <  B then "before, " else "") &
	 (if A >  B then "after, " else "") &
	 (if A <= B then "<=, " else "(not <=), ") & "and " &
	 (if A >= B then ">=. " else "(not >=).") );
   end Print_Comparison;

begin
   Print_Comparison("this", "that");
   Print_Comparison("that", "this");
   Print_Comparison("THAT", "That");
   Print_Comparison("this", "This");
   Print_Comparison("this", "this");
   Print_Comparison("the", "there");
   Print_Comparison("there", "the");
end String_Compare;
