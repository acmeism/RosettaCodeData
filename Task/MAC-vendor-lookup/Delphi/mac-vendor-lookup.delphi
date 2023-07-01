program MAC_Vendor_Lookup;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  IdHttp;

function macLookUp(mac: string): string;
begin
  Result := '';
  with TIdHTTP.Create(nil) do
  begin
    try
      Result := Get('http://api.macvendors.com/' + mac);

    except
      on E: Exception do
        Writeln(e.Message);
    end;
    Free;
  end;
end;

begin
  Writeln(macLookUp('FC-A1-3E'));
  sleep(1000);
  Writeln(macLookUp('FC:FB:FB:01:FA:21'));
  sleep(1000);
  Writeln(macLookUp('BC:5F:F4'));
  readln;
end.
