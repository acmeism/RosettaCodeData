Program CheckCRC;
{$IFDEF fpc}{$mode Delphi}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,crc;

function CrcString(const mystring: string) : longword;
var
  crcvalue: longword;
begin
  crcvalue := crc32(0,nil,0);
  result := crc32(crcvalue, @mystring[1], length(mystring));
end;

var
  mytext: string;
begin
  myText := 'The quick brown fox jumps over the lazy dog';
  writeln('crc32 = ', IntToHex(CrcString(mytext), 8));
end.
