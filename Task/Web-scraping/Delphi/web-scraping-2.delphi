program ReadUTCTime;

{$APPTYPE CONSOLE}

uses SysUtils, Classes, IdHTTP;

var
  s: string;
  lHTTP: TIdHTTP;
  lReader: TStringReader;
begin
  lHTTP := TIdHTTP.Create(nil);
  try
    lReader := TStringReader.Create(lHTTP.Get('http://tycho.usno.navy.mil/cgi-bin/timer.pl'));
    while lReader.Peek > 0 do
    begin
      s := lReader.ReadLine;
      if Pos('UTC', s) > 0 then
      begin
        Writeln(s);
        Break;
      end;
    end;
  finally
    lHTTP.Free;
    lReader.Free;
  end;
end.
