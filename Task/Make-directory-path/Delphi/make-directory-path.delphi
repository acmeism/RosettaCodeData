program Make_directory_path;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils;

const
  Path1 = '.\folder1\folder2\folder3'; // windows relative path (others OS formats are acepted)
  Path2 = 'folder4\folder5\folder6';

begin
  // "ForceDirectories" work with relative path if start with "./"
  if ForceDirectories(Path1) then
    Writeln('Created "', path1, '" sucessfull.');

  // "TDirectory.CreateDirectory" work with any path format
  //  but don't return sucess, requere "TDirectory.Exists" to check
  TDirectory.CreateDirectory(Path2);
  if TDirectory.Exists(Path2) then
    Writeln('Created "', path2, '" sucessfull.');
  Readln;
end.
