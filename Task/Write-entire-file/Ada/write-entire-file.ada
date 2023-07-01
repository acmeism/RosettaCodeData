with Ada.Text_IO;  use Ada.Text_IO;

procedure Write_Whole_File is
   File_Name : constant String := "the_file.txt";

   F : File_Type;
begin
   begin
      Open (F, Mode => Out_File, Name => File_Name);
   exception
      when Name_Error => Create (F, Mode => Out_File, Name => File_Name);
   end;

   Put (F, "(Over)write a file so that it contains a string. "               &
           "The reverse of Read entire file—for when you want to update or " &
           "create a file which you would read in its entirety all at once.");
   Close (F);
end Write_Whole_File;
