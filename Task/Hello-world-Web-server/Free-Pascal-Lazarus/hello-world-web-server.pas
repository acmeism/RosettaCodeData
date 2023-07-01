program HelloWorldServer;
{$mode objfpc}{$H+}
uses
  Classes, fphttpserver;

Type
  TTestHTTPServer = Class(TFPHTTPServer)
  public
    procedure HandleRequest(Var ARequest: TFPHTTPConnectionRequest;
                            Var AResponse : TFPHTTPConnectionResponse); override;
  end;

Var
  Serv : TTestHTTPServer;

procedure TTestHTTPServer.HandleRequest(var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
Var
  F : TStringStream;
begin
  F:=TStringStream.Create('Hello,World!');
  try
    AResponse.ContentLength:=F.Size;
    AResponse.ContentStream:=F;
    AResponse.SendContent;
    AResponse.ContentStream:=Nil;
  finally
    F.Free;
  end;
end;

begin
  Serv:=TTestHTTPServer.Create(Nil);
  try
    Serv.Threaded:=False;
    Serv.Port:=8080;
    Serv.AcceptIdleTimeout:=1000;
    Serv.Active:=True;
  finally
    Serv.Free;
  end;
end.
