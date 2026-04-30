with Ada.Wide_Wide_Text_IO;

use Ada.Wide_Wide_Text_IO;

procedure Read_UTF8 is
   procedure Read (Filename : String) is
      File : File_Type;
      C : Wide_Wide_Character;
   begin
      Open (File, In_File, Filename);
      Set_Input (File);
      while not End_Of_File loop
         Get (C);
         Put (C);
      end loop;
      Close (File);
   end Read;

begin
   Read ("input.txt");
end Read_UTF8;
