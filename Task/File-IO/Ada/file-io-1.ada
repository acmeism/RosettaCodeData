with Ada.Text_IO; use Ada.Text_IO;

procedure Read_And_Write_File_Line_By_Line is
   Input, Output : File_Type;
begin
   Open (File => Input,
         Mode => In_File,
         Name => "input.txt");
   Create (File => Output,
           Mode => Out_File,
           Name => "output.txt");
   loop
      declare
         Line : String := Get_Line (Input);
      begin
         -- You can process the contents of Line here.
         Put_Line (Output, Line);
      end;
   end loop;
exception
   when End_Error =>
      Close (Input);
      Close (Output);
end Read_And_Write_File_Line_By_Line;
