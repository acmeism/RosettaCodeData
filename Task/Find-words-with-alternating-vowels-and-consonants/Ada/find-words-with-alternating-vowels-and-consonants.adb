with Ada.Text_Io;
with Ada.Strings.Fixed;

procedure Find_Alternating is
   use Ada.Text_Io;

   function Is_Vowel (Letter : Character) return Boolean
   is (Ada.Strings.Fixed.Index ("aeiou", "" & Letter) /= 0);

   Filename : constant String := "unixdict.txt";
   File     : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word   : constant String  := Get_Line (File);
         Failed : Boolean := False;
         Vowel  : Boolean := not Is_Vowel (Word (Word'First));
      begin
         for Letter of Word loop
            if Vowel = Is_Vowel (letter) then
               Failed := True;
               exit;
            end if;
            Vowel := not Vowel;
         end loop;
         if not Failed and Word'Length > 9 then
            Put_Line (Word);
         end if;
      end;
   end loop;
   Close (File);
end Find_Alternating;
