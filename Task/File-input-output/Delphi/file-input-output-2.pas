var
  f         : File ;
  buff      : array[1.1024] of byte ;
  BytesRead : Integer ;
begin
  AssignFile(f,fully qualified file name);
  Reset(f,1);
  Blockread(f,Buff,SizeOf(Buff),BytesRead);
  CloseFile(f);
end;
