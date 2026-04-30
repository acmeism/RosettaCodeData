with Ada.Text_IO;     use Ada.Text_IO;
with System.OS_Lib;   use System.OS_Lib;

procedure Execute_Synchronously is
   Result    : Integer;
   Arguments : Argument_List :=
                 (  1=> new String'("cmd.exe"),
                    2=> new String'("/C dir c:\temp\*.adb")
                 );
begin
   Spawn
   (  Program_Name           => "cmd.exe",
      Args                   => Arguments,
      Output_File_Descriptor => Standout,
      Return_Code            => Result
   );
   for Index in Arguments'Range loop
      Free (Arguments (Index)); -- Free the argument list
   end loop;
end Execute_Synchronously;
