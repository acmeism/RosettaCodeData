program ShowHTTP;

{$APPTYPE CONSOLE}

uses IdHttp;

var
  s: string;
  lHTTP: TIdHTTP;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    lHTTP.HandleRedirects := True;
    s := lHTTP.Get('http://www.rosettacode.org');
    Writeln(s);
  finally
    lHTTP.Free;
  end;
end.
