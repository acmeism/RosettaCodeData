with Ada.Command_Line;
with Ada.Directories;
with Ada.Text_IO;

procedure Make_Directory_Path is
begin
   if Ada.Command_Line.Argument_Count /= 1 then
      Ada.Text_IO.Put_Line ("Usage: make_directory_path <path/to/dir>");
      return;
   end if;

   declare
      Path : String renames Ada.Command_Line.Argument (1);
   begin
      Ada.Directories.Create_Path (Path);
   end;
end Make_Directory_Path;
