program Base64Decoder;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.NetEncoding;

const
  Src = 'VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=';

begin
  WriteLn(Format('Source string: ' + sLineBreak + '"%s"', [Src]));
  WriteLn(Format('Decoded string: ' + sLineBreak + '"%s"', [TNetEncoding.Base64.Decode(Src)]));

end.
