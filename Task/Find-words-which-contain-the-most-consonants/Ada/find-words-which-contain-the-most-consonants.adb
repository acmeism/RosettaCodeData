with Ada.Text_Io;
with Ada.Strings.Fixed;
with Ada.Containers.Indefinite_Vectors;

procedure Most_Consonants is
   use Ada.Text_Io;

   package String_Vectors is
     new Ada.Containers.Indefinite_Vectors (Index_Type   => Positive,
                                            Element_Type => String);

   function Is_Vowel (Letter : Character) return Boolean
   is (Ada.Strings.Fixed.Index ("aeiou", "" & Letter) /= 0);

   type Consonant_Count is range 0 .. 15;
   Filename : constant String := "unixdict.txt";
   File     : File_Type;
   Words    : array (Consonant_Count) of String_Vectors.Vector;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word  : constant String  := Get_Line (File);
         Found : array (Character) of Boolean := (others => False);
         Conso : Consonant_Count := 0;
         Bad   : Boolean         := False;
      begin
         for Letter of Word loop
            if Is_Vowel (Letter) then
               null;
            elsif Found (Letter) then
               Bad := True;
            else
               Found (Letter) := True;
               Conso := Conso + 1;
            end if;
         end loop;
         if not Bad and Word'Length > 10 then
            Words (Conso).Append (Word);
         end if;
      end;
   end loop;
   Close (File);


   for Cons in Words'Range loop
      if not Words (Cons).Is_Empty then
         Put (Cons'Image & " consonants: ");
         Put (Words (Cons).Length'Image & " words");
         New_Line;
      end if;
      declare
         Column : Natural := 0;
         Image  : String (1 .. 15);
      begin
         for Word of Words (Cons) loop
            Ada.Strings.Fixed.Move (Word, Image);
            Put (Image);
            Column := Column + 1;
            if Column mod 8 = 0 then
               New_Line;
            end if;
         end loop;
      end;
      if not Words (Cons).Is_Empty then
         New_Line;
      end if;
   end loop;

end Most_Consonants;
