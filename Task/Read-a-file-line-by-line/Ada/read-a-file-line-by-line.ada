with Ada.Text_IO;  use Ada.Text_IO;

procedure Line_By_Line is
   File : File_Type;
begin
   Open (File => File,
         Mode => In_File,
         Name => "line_by_line.adb");
   While not  End_Of_File (File) Loop
      Put_Line (Get_Line (File));
   end loop;

   Close (File);
end Line_By_Line;
