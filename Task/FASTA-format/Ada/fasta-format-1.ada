with Ada.Text_IO; use Ada.Text_IO;

procedure Simple_FASTA is

   Current: Character;

begin
   Get(Current);
   if Current /= '>' then
      raise Constraint_Error with "'>' expected";
   end if;
   while not End_Of_File loop -- read name and string
      Put(Get_Line & ": "); -- read name and write directly to output
      Read_String:
      loop
	 exit Read_String when End_Of_File; -- end of input
	 Get(Current);
	 if Current = '>' then -- next name
	    New_Line;
	    exit Read_String;
	 else
	    Put(Current & Get_Line);
	    -- read part of string and write directly to output
	 end if;
      end loop Read_String;
   end loop;

end Simple_FASTA;
