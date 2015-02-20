uses
  classes;
begin
  with TFileStream.Create('input.txt', fmOpenRead) do
  try
    SaveToFile('output.txt');
  finally
    Free;
  end;
end;
