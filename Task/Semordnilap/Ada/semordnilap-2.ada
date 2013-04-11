package body String_Vectors is

   function Is_In(List: Vec;
                  Word: String;
                  Start: Positive; Stop: Natural) return Boolean is
      Middle: Positive;
   begin
      if Start > Stop then
         return False;
      else
         Middle := (Start+Stop) / 2;
            if List.Element(Middle) = Word then
               return True;
            elsif List.Element(Middle) < Word then
               return List.Is_In(Word, Middle+1, Stop);
            else
               return List.Is_In(Word, Start, Middle-1);
            end if;
      end if;
   end Is_In;

   function Read(Filename: String) return Vec is
      package IO renames Ada.Text_IO;
      Persistent_List: IO.File_Type;
      List: Vec;
   begin
      IO.Open(File => Persistent_List, Name => Filename, Mode => IO.In_File);
      while not IO.End_Of_File(Persistent_List) loop
         List.Append(New_Item => IO.Get_Line(Persistent_List));
      end loop;
      IO.Close(Persistent_List);
      return List;
   end Read;

end String_Vectors;
