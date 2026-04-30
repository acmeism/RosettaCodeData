with Ada.Command_Line, Ada.Text_IO, Ada.Strings.Fixed;

procedure Rep_String is

   function Find_Largest_Rep_String(S:String) return String is
      L: Natural := S'Length;
   begin
      for I in reverse 1 .. L/2 loop
	 declare
	    use Ada.Strings.Fixed;
	    T: String := S(S'First .. S'First + I-1); -- the first I characters of S
	    U: String := (1+(L/I)) * T; -- repeat T so often that U'Length >= L
	 begin -- compare first L characers of U with S
	    if U(U'First .. U'First + S'Length -1) = S then
	       return T; -- T is a rep-string
	    end if;
	 end;
      end loop;
      return ""; -- no rep string;
   end Find_Largest_Rep_String;

   X: String := Ada.Command_Line.Argument(1);
   Y: String := Find_Largest_Rep_String(X);

begin
   if Y="" then
      Ada.Text_IO.Put_Line("No rep-string for """ & X & """");
   else
      Ada.Text_IO.Put_Line("Longest rep-string for """& X &""": """& Y &"""");
   end if;
end Rep_String;
