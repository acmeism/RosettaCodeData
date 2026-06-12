program URLShortenerServer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Json,
  IdHTTPServer,
  IdContext,
  IdCustomHTTPServer,
  IdGlobal,
  Inifiles;

type
  TUrlShortener = class
  private
    Db: TInifile;
    Server: TIdHTTPServer;
    function GenerateKey(size: integer): string;
    procedure Get(Path: string; AResponseInfo: TIdHTTPResponseInfo);
    procedure Post(Url: string; AReqBody: TJSONValue; AResponseInfo: TIdHTTPResponseInfo);
    function PostBody(Data: TStream): TJSONValue;
    function StoreLongUrl(Url: string): string;
  public
    procedure DoGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure StartListening;
    constructor Create;
    destructor Destroy; override;
  end;

const
  Host = 'localhost:8080';
  CODE_CHARS = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  SHORTENER_SEASON = 'URL_SHORTER';

{ Manager }

function TUrlShortener.GenerateKey(size: integer): string;
var
  le, i: integer;
begin
  SetLength(Result, size);
  le := Length(CODE_CHARS)-1;
  for i := 1 to size do
    Result[i] := CODE_CHARS[Random(le)+1];
end;

procedure TUrlShortener.StartListening;
begin
  Server.Active := true;
end;

function TUrlShortener.StoreLongUrl(Url: string): string;
begin
  repeat
    Result := GenerateKey(8);
  until not Db.ValueExists(SHORTENER_SEASON, Result);
  Db.WriteString(SHORTENER_SEASON, Result, Url);
  Db.UpdateFile;
end;

procedure TUrlShortener.Get(Path: string; AResponseInfo: TIdHTTPResponseInfo);
var
  longUrl: string;
begin
  if Db.ValueExists(SHORTENER_SEASON, Path) then
  begin
    longUrl := Db.ReadString(SHORTENER_SEASON, Path, '');
    AResponseInfo.ResponseNo := 302;
    AResponseInfo.Redirect(longUrl);
  end
  else
  begin
    AResponseInfo.ResponseNo := 404;
    writeln(format('No such shortened url: http://%s/%s', [host, Path]));
  end;
end;

procedure TUrlShortener.Post(Url: string; AReqBody: TJSONValue; AResponseInfo:
  TIdHTTPResponseInfo);
var
  longUrl, shortUrl: string;
begin
  if Assigned(AReqBody) then
  begin
    longUrl := AReqBody.GetValue<string>('long');
    shortUrl := StoreLongUrl(longUrl);
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentText := Host + '/' + shortUrl;
  end
  else
    AResponseInfo.ResponseNo := 422;
end;

function TUrlShortener.PostBody(Data: TStream): TJSONValue;
var
  body: string;
begin
  Result := nil;
  if assigned(Data) then
  begin
    Data.Position := 0;
    body := ReadStringFromStream(Data);

    result := TJSONObject.Create;
    try
      result := TJSONObject.ParseJSONValue(body);
    except
      on E: Exception do
        FreeAndNil(Result);
    end;
  end;
end;

constructor TUrlShortener.Create;
begin
  Db := TInifile.Create(ChangeFileExt(ParamStr(0), '.db'));
  Server := TIdHTTPServer.Create(nil);
  Server.DefaultPort := 8080;
  Server.OnCommandGet := DoGet;
end;

destructor TUrlShortener.Destroy;
begin
  Server.Active := false;
  Server.Free;
  Db.Free;
  inherited;
end;

procedure TUrlShortener.DoGet(AContext: TIdContext; ARequestInfo:
  TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  Path: string;
begin
  // Default  ResponseNo
  AResponseInfo.ResponseNo := 404;

  Path := ARequestInfo.URI.Replace('/', '', []);

  case ARequestInfo.CommandType of
    hcGET:
      Get(Path, AResponseInfo);
    hcPOST:
      Post(Path, PostBody(ARequestInfo.PostStream), AResponseInfo);
  else
    Writeln('Unsupprted method: ', ARequestInfo.Command);
  end;
end;

var
  Server: TIdHTTPServer;
  Manager: TUrlShortener;

begin
  Manager := TUrlShortener.Create;
  Manager.StartListening;

  Writeln('Running on ', host);
  Writeln('Press ENTER to exit');
  readln;

  Manager.Free;
end.
