program CalcCRC32;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.ZLib;

var
  Data: AnsiString = 'The quick brown fox jumps over the lazy dog';
  CRC: UInt32;

begin
  CRC := crc32(0, @Data[1], Length(Data));
  WriteLn(Format('CRC32 = %8.8X', [CRC]));
end.
