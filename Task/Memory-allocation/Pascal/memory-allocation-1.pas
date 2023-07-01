type
  TByteArray = array of byte;
var
  A: TByteArray;
begin
  setLength(A,1000);
...
  setLength(A,0);
end;
