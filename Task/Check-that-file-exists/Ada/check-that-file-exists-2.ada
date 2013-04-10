with Ada.Text_IO; use Ada.Text_IO;
with Ada.Directories; use Ada.Directories;

procedure File_Exists is
   procedure Print_File_Exist (Name : String) is
   begin
      Put_Line ("Does " & Name & " exist? " &
                  Boolean'Image (Exists (Name)));
   end Print_File_Exist;
   procedure Print_Dir_Exist (Name : String) is
   begin
      Put_Line ("Does directory " & Name & " exist? " &
                  Boolean'Image (Exists (Name) and then Kind (Name) = Directory));
   end Print_Dir_Exist;
begin
   Print_File_Exist ("input.txt" );
   Print_File_Exist ("/input.txt");
   Print_Dir_Exist ("docs");
   Print_Dir_Exist ("/docs");
end File_Exists;
