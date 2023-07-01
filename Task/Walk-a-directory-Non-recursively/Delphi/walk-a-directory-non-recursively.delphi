program Walk_a_directory;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.IOUtils;

var
  Files: TArray<string>;
  FileName, Directory: string;

begin
  Directory := TDirectory.GetCurrentDirectory;  // dir = '.', work to
  Files := TDirectory.GetFiles(Directory, '*.*');

  for FileName in Files do
  begin
    Writeln(FileName);
  end;

  Readln;
end.
