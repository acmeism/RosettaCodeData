program createFile;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils;

const
  filename = 'output.txt';

var
  cwdPath,
  fsPath: string;


// Create empty file in current working directory
function CreateEmptyFile1: Boolean;
var
  f: textfile;
begin
  // Make path to the file to be created
  cwdPath := ExtractFilePath(ParamStr(0)) + '1_'+filename;

  // Create file
  AssignFile(f,cwdPath);
  {$I-}
  Rewrite(f);
  {$I+}
  Result := IOResult = 0;
  CloseFile(f);
end;

// Create empty file in filesystem root
function CreateEmptyFile2: Boolean;
var
  f: textfile;
begin
  // Make path to the file to be created
  fsPath := ExtractFileDrive(ParamStr(0)) + '\' + '2_'+filename;

  // Create file
  AssignFile(f,fsPath);
  {$I-}
  Rewrite(f);
  {$I+}
  Result := IOResult = 0;
  CloseFile(f);
end;

function CreateEmptyFile3: Boolean;
var
  fs: TFileStream;
begin
  // Make path to the file to be created
  cwdPath := ExtractFilePath(ParamStr(0)) + '3_'+filename;

  // Create file
  fs := TFileStream.Create(cwdPath,fmCreate);
  fs.Free;
  Result := FileExists(cwdPath);
end;

function CreateEmptyFile4: Boolean;
var
  fs: TFileStream;
begin
  // Make path to the file to be created
  fsPath := ExtractFileDrive(ParamStr(0)) + '\' + '4_'+filename;

  // Create file
  fs := TFileStream.Create(fsPath,fmCreate);
  fs.Free;
  Result := FileExists(fsPath);
end;

begin
  if CreateEmptyFile1 then
    Writeln('File created at '+cwdPath)
    else
    Writeln('Error creating file at '+cwdPath);

  if CreateEmptyFile2 then
    Writeln('File created at '+fsPath)
    else
    Writeln('Error creating file at '+fsPath);

  if CreateEmptyFile3 then
    Writeln('File created at '+cwdPath)
    else
    Writeln('Error creating file at '+cwdPath);

  if CreateEmptyFile4 then
    Writeln('File created at '+fsPath)
    else
    Writeln('Error creating file at '+fsPath);

  // Keep console window open
  Readln;
end.
