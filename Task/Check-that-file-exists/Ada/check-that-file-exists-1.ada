with Ada.Text_IO; use Ada.Text_IO;

procedure File_Exists is
   function Does_File_Exist (Name : String) return Boolean is
      The_File : Ada.Text_IO.File_Type;
   begin
      Open (The_File, In_File, Name);
      Close (The_File);
      return True;
   exception
      when Name_Error =>
         return False;
   end Does_File_Exist;
begin
   Put_Line (Boolean'Image (Does_File_Exist ("input.txt" )));
   Put_Line (Boolean'Image (Does_File_Exist ("\input.txt")));
end File_Exists;
