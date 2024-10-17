program Sockets;

{$APPTYPE CONSOLE}

uses IdTCPClient;

var
  lTCPClient: TIdTCPClient;
begin
  lTCPClient := TIdTCPClient.Create(nil);
  try
    lTCPClient.Host := '127.0.0.1';
    lTCPClient.Port := 256;
    lTCPClient.Connect;
    lTCPClient.IOHandler.WriteLn('hello socket world');
  finally
    lTCPClient.Free;
  end;
end.
