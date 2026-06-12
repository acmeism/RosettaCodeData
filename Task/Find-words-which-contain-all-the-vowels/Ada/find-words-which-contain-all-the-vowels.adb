with Ada.Text_Io;
with Ada.Strings.Maps;
with Ada.Strings.Fixed;

procedure Find_All_Vowels is
   use Ada.Text_Io;
   use Ada.Strings;

   type Vowels     is ('a', 'e', 'i', 'o', 'u');
   type Count_Type is array (Vowels) of Natural;

   Filename : constant String := "unixdict.txt";
   Chars    : constant array (Vowels) of Character := "aeiou";
   File     : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word  : constant String  := Get_Line (File);
         Count : Count_Type;
      begin
         for Vowel in Vowels loop
            Count (Vowel) := Fixed.Count (Word, Maps.To_Set (Chars (Vowel)));
         end loop;

         if Count = Count_Type'(others => 1) and Word'Length > 10 then
            Put_Line (Word);
         end if;
      end;
   end loop;
   Close (File);
end Find_All_Vowels;
