program ShowHTTPSAuthenticated;

{$APPTYPE CONSOLE}

uses IdHttp, IdSSLOpenSSL;

var
  s: string;
  lHTTP: TIdHTTP;
  lIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  ReportMemoryLeaksOnShutdown := True;
  lHTTP := TIdHTTP.Create(nil);
  lIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    lHTTP.Request.Username := 'USERNAME';
    lHTTP.Request.Password := 'PASSWD';
    lHTTP.IOHandler := lIOHandler;
    lHTTP.HandleRedirects := True;
    s := lHTTP.Get('https://SomeSecureSite.net/');
    Writeln(s);
  finally
    lHTTP.Free;
    lIOHandler.Free;
  end;
end.
