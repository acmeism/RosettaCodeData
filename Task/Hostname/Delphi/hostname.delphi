program ShowHostName;

{$APPTYPE CONSOLE}

uses Windows;

var
  lHostName: array[0..255] of char;
  lBufferSize: DWORD;
begin
  lBufferSize := 256;
  if GetComputerName(lHostName, lBufferSize) then
    Writeln(lHostName)
  else
    Writeln('error getting host name');
end.
