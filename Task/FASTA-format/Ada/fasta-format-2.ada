with Ada.Text_IO, Ada.Containers.Indefinite_Ordered_Maps; use Ada.Text_IO;

procedure FASTA is
   package Maps is new  Ada.Containers.Indefinite_Ordered_Maps
     (Element_Type => String, Key_Type => String);
   Map: Maps.Map; -- Map holds the full file (as pairs of name and value)

   function Get_Value(Previous: String := "") return String is
      Current: Character;
   begin
      if End_Of_File then
	 return Previous; -- file ends
      else
	 Get(Current); -- read first character
	 if Current = '>' then -- ah, a new name begins
	    return Previous; -- the string read so far is the value
	 else -- the entire line is part of the value
	    return Get_Value(Previous & Current & Get_Line);
	 end if;
      end if;
   end Get_Value;

   procedure Print_Pair(Position: Maps.Cursor) is
   begin
      Put_Line(Maps.Key(Position) & ": " & Maps.Element(Position));
      -- Maps.Key(X) is the name and Maps.Element(X) is the value at X
   end Print_Pair;

   Skip_This: String := Get_Value;
   -- consumes the entire file, until the first line starting with '>'.
   -- the string Skip_This should be empty, but we don't verify this

begin
   while not End_Of_File loop -- read the file into Map
      declare
	 Name: String := Get_Line;
	   -- reads all characters in the line, except for the first ">"
	 Value: String := Get_Value;
      begin
	 Map.Insert(Key => Name, New_Item => Value);
	 -- adds the pair (Name, Value) to Map
      end;
   end loop;

   Map.Iterate(Process => Print_Pair'Access); -- print Map
end FASTA;
