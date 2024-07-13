procedure TruncateFile(name: string; length: integer);
begin
  var f: file of byte;
  Reset(f,name);
  if f.Size < length then
    raise new System.ArgumentOutOfRangeException('length','The specified length is greater than length of the file');
  f.Position := length;
  f.Truncate;
  f.Close;
end;

begin
  TruncateFile('aaa.txt',3);
end.
