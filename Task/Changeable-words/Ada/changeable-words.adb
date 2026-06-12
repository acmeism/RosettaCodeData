with Ada.Text_Io;
with Ada.Strings.Fixed;
with Ada.Containers.Indefinite_Vectors;

procedure Changeable is
   use Ada.Text_Io, Ada.Strings.Fixed;

   package String_Vectors is
     new Ada.Containers.Indefinite_Vectors (Index_Type   => Positive,
                                            Element_Type => String);

   Filename : constant String := "unixdict.txt";
   File     : File_Type;
   Words    : String_Vectors.Vector;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word : constant String := Get_Line (File);
      begin
         if Word'Length > 11 then
            Words.Append (Word);
         end if;
      end;
   end loop;
   Close (File);

   for Word_Index_1 in Words.First_Index .. Words.Last_Index loop
      for Word_Index_2 in Word_Index_1 + 1 .. Words.Last_Index loop
         declare
            Image  : String (1 .. 14);
            Word_1 : String renames Words (Word_Index_1);
            Word_2 : String renames Words (Word_Index_2);
            Match  : Natural := 0;
         begin
            if Word_1'Length = Word_2'Length then
               for Index in Word_1'Range loop
                  if Word_1 (Index) = Word_2 (Index) then
                     Match := Match + 1;
                  end if;
               end loop;
               if Match = Word_1'Length - 1 then
                  Move (Word_1, Image);
                  Put (Image); Put (" <-> ");
                  Move (Word_2, Image);
                  Put_Line (Image);
               end if;
            end if;
         end;
      end loop;
   end loop;
end Changeable;
