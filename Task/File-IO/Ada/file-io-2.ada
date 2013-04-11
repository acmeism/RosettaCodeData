with Ada.Command_Line, Ada.Text_IO; use Ada.Command_Line, Ada.Text_IO;

procedure Read_And_Write_File_Line_By_Line is
   Read_From : constant String := "input.txt";
   Write_To  : constant String := "output.txt";

   Input, Output : File_Type;
begin
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Read_From);
   exception
      when others =>
         Put_Line (Standard_Error,
                   "Can not open the file '" & Read_From & "'. Does it exist?");
         Set_Exit_Status (Failure);
         return;
   end;

   begin
      Create (File => Output,
              Mode => Out_File,
              Name => Write_To);
   exception
      when others =>
         Put_Line (Standard_Error,
                   "Can not create a file named '" & Write_To & "'.");
         Set_Exit_Status (Failure);
         return;
   end;

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
