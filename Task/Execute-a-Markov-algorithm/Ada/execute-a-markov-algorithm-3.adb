with Ada.Command_Line;
with Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded;
with Markov;

procedure Test_Markov is
   use Ada.Strings.Unbounded;
   package IO renames Ada.Text_IO.Unbounded_IO;
   Rule_File  : Ada.Text_IO.File_Type;
   Line_Count : Natural := 0;
begin
   if Ada.Command_Line.Argument_Count /= 2 then
      Ada.Text_IO.Put_Line ("Usage: test_markov ruleset_file source_file");
      return;
   end if;
   Ada.Text_IO.Open
     (File => Rule_File,
      Mode => Ada.Text_IO.In_File,
      Name => Ada.Command_Line.Argument (1));
   while not Ada.Text_IO.End_Of_File (Rule_File) loop
      Ada.Text_IO.Skip_Line (Rule_File);
      Line_Count := Line_Count + 1;
   end loop;
   declare
      Lines : Markov.String_Array (1 .. Line_Count);
   begin
      Ada.Text_IO.Reset (Rule_File);
      for I in Lines'Range loop
         Lines (I) := IO.Get_Line (Rule_File);
      end loop;
      Ada.Text_IO.Close (Rule_File);

      declare
         Ruleset     : Markov.Ruleset := Markov.Parse (Lines);
         Source_File : Ada.Text_IO.File_Type;
      begin
         Ada.Text_IO.Open
           (File => Source_File,
            Mode => Ada.Text_IO.In_File,
            Name => Ada.Command_Line.Argument (2));
         while not Ada.Text_IO.End_Of_File (Source_File) loop
            Ada.Text_IO.Put_Line
              (Markov.Apply (Ruleset, Ada.Text_IO.Get_Line (Source_File)));
         end loop;
         Ada.Text_IO.Close (Source_File);
      end;
   end;
end Test_Markov;
