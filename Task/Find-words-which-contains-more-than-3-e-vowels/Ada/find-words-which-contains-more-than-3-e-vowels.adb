with Ada.Text_Io;
with Ada.Strings.Maps;
with Ada.Strings.Fixed;

procedure Find_Three_E is
   use Ada.Text_Io;
   use Ada.Strings;
   use type Ada.Strings.Maps.Character_Set;

   Filename   : constant String  := "unixdict.txt";
   Y_Is_Vowel : constant Boolean := False;
   Set_E      : constant Maps.Character_Set := Maps.To_Set ("eE");
   Set_Y      : constant Maps.Character_Set := Maps.To_Set ("yY");
   Set_Others : constant Maps.Character_Set :=
     Maps.To_Set ("aiouAIOU") or (if Y_Is_Vowel then Set_Y else Maps.Null_Set);
   File       : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word         : constant String  := Get_Line (File);
         Count_E      : constant Natural := Fixed.Count (Word, Set_E);
         Count_Others : constant Natural := Fixed.Count (Word, Set_Others);
      begin
         if Count_E > 3 and Count_Others = 0 then
            Put_Line (Word);
         end if;
      end;
   end loop;
   Close (File);
end Find_Three_E;
