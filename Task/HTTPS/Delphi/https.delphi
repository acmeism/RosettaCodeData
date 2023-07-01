program ShowHTTPS;

{$APPTYPE CONSOLE}

uses IdHttp, IdSSLOpenSSL;

var
  s: string;
  lHTTP: TIdHTTP;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    lHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(lHTTP);
    lHTTP.HandleRedirects := True;
    s := lHTTP.Get('https://sourceforge.net/');
    Writeln(s);
  finally
    lHTTP.Free;
  end;
end.
