program Base64EncodeData;
{$APPTYPE CONSOLE}
uses IdHTTP, IdCoderMIME;

var
  lSrcString: string;
  lHTTP: TIdHTTP;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    lSrcString := lHTTP.Get('http://rosettacode.org/favicon.ico');
    Writeln(TIdEncoderMIME.EncodeString(lSrcString));
  finally
    lHTTP.Free;
  end;
end.
