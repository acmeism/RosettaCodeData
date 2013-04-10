program DNSQuerying;

{$APPTYPE CONSOLE}

uses
  IdGlobal, IdStackWindows;

const
  DOMAIN_NAME = 'www.kame.net';
var
  lStack: TIdStackWindows;
begin
  lStack := TIdStackWindows.Create;
  try
    Writeln(DOMAIN_NAME);
    Writeln('IPv4: ' + lStack.ResolveHost(DOMAIN_NAME));
    Writeln('IPv6: ' + lStack.ResolveHost(DOMAIN_NAME, Id_IPv6));
  finally
    lStack.Free;
  end;
end.
