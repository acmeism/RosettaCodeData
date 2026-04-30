with Ada.Text_IO;  use Ada.Text_IO;

procedure Rosetta_Read is
   File : File_Type;
begin
   Open (File => File,
         Mode => In_File,
         Name => "rosetta_read.adb");
   Set_Line (File, To => 7);

   declare
      Line_7 : constant String := Get_Line (File);
   begin
      if Line_7'Length = 0 then
         Put_Line ("Line 7 is empty.");
      else
         Put_Line (Line_7);
      end if;
   end;

   Close (File);
exception
   when End_Error =>
      Put_Line ("The file contains fewer than 7 lines.");
      Close (File);
   when Storage_Error =>
      Put_Line ("Line 7 is too long to load.");
      Close (File);
end Rosetta_Read;
