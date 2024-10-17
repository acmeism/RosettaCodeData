program HelloWorldWebServer;

{$APPTYPE CONSOLE}

uses SysUtils, IdContext, IdCustomHTTPServer, IdHTTPServer;

type
  TWebServer = class
  private
    FHTTPServer: TIdHTTPServer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  end;

constructor TWebServer.Create;
begin
  FHTTPServer := TIdHTTPServer.Create(nil);
  FHTTPServer.DefaultPort := 8080;
  FHTTPServer.OnCommandGet := HTTPServerCommandGet;
  FHTTPServer.Active := True;
end;

destructor TWebServer.Destroy;
begin
  FHTTPServer.Active := False;
  FHTTPServer.Free;
  inherited Destroy;
end;

procedure TWebServer.HTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := 'Goodbye, World!';
end;

var
  lWebServer: TWebServer;
begin
  lWebServer := TWebServer.Create;
  try
    Writeln('Delphi Hello world/Web server ');
    Writeln('Press Enter to quit');
    Readln;
  finally
    lWebServer.Free;
  end;
end.
