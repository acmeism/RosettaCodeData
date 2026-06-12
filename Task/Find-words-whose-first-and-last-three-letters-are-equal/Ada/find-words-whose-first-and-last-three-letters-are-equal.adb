with Ada.Text_Io;
with Ada.Strings.Fixed;

procedure Find_Three_Equals is
   use Ada.Text_Io;
   use Ada.Strings.Fixed;

   Filename : constant String := "unixdict.txt";
   File     : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word  : constant String  := Get_Line (File);
         First : String renames Head (Word, 3);
         Last  : String renames Tail (Word, 3);
      begin
         if First = Last and Word'Length > 5 then
            Put_Line (Word);
         end if;
      end;
   end loop;
   Close (File);
end Find_Three_Equals;
