with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure Main is
   type col_count is mod 6;
   package AF renames Ada.Strings.Fixed;

   file_name : String             := "unixdict.txt";
   The_File  : File_Type;
   Inpt_Str  : String (1 .. 40);
   Length    : Natural;
   pattern   : String             := "the";
   Columns   : col_count          := 0;
   Tally     : Natural            := 0;
   sep       : constant Character := HT;
begin

   Open (File => The_File, Mode => In_File, Name => file_name);

   while not End_Of_File (The_File) loop
      Get_Line (File => The_File, Item => Inpt_Str, Last => Length);

      if Length > 11
        and then
          AF.Count (Source => Inpt_Str (1 .. Length), Pattern => pattern) > 0
      then
         Tally   := Tally + 1;
         Columns := Columns + 1;
         Put (Inpt_Str (1 .. Length) & sep);
         if Columns = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;
   Put_Line ("Found" & Tally'Image & " ""the"" words");
   Close (The_File);
end Main;
