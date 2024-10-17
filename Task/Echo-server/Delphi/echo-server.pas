program EchoServer;

{$APPTYPE CONSOLE}

uses SysUtils, IdContext, IdTCPServer;

type
  TEchoServer = class
  private
    FTCPServer: TIdTCPServer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure TCPServerExecute(AContext: TIdContext);
  end;

constructor TEchoServer.Create;
begin
  FTCPServer := TIdTCPServer.Create(nil);
  FTCPServer.DefaultPort := 12321;
  FTCPServer.OnExecute := TCPServerExecute;
  FTCPServer.Active := True;
end;

destructor TEchoServer.Destroy;
begin
  FTCPServer.Active := False;
  FTCPServer.Free;
  inherited Destroy;
end;

procedure TEchoServer.TCPServerExecute(AContext: TIdContext);
var
  lCmdLine: string;
begin
  lCmdLine := AContext.Connection.IOHandler.ReadLn;
  Writeln('>' + lCmdLine);
  AContext.Connection.IOHandler.Writeln('>' + lCmdLine);

  if SameText(lCmdLine, 'QUIT') then
  begin
    AContext.Connection.IOHandler.Writeln('Disconnecting');
    AContext.Connection.Disconnect;
  end;
end;

var
  lEchoServer: TEchoServer;
begin
  lEchoServer := TEchoServer.Create;
  try
    Writeln('Delphi Echo Server');
    Writeln('Press Enter to quit');
    Readln;
  finally
    lEchoServer.Free;
  end;
end.
