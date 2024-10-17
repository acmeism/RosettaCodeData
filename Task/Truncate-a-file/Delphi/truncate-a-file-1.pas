procedure TruncateFile(FileName : string; NewSize : integer);
var
  aFile:   file of byte;
begin
  Assign(aFile, FileName);
  Reset(aFile);
  try
    Seek(afile, NewSize);
    Truncate(aFile);
  finally
    Close(afile);
  end;
end;
