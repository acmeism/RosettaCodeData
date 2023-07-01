procedure TruncateFile(FileName : string; NewSize : integer);
var
  Stream : TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenReadWrite, fmShareExclusive);
  try
    Stream.Size := NewSize;
  finally
    Stream.Free;
  end;
end;
