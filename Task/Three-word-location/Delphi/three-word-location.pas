program Three_word_location;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TThreeWordLocation = array of string;

  TGlobalPosition = record
  private
    FLatitude: Double;
    FLongitude: Double;
    FWs: TThreeWordLocation;
    class function toWord(w: int64): string; static;
    class function fromWord(ws: string): int64; static;
    procedure SetLatitude(const Value: Double);
    procedure SetLongitude(const Value: Double);
    procedure Recalculate;
    function GetTWLocationAsStr: string;
  public
    constructor Create(_lat, _lon: Double); overload;
    constructor Create(Ws: TThreeWordLocation); overload;
    procedure Assign(Ws: TThreeWordLocation);
    property Latitude: Double read FLatitude write SetLatitude;
    property Longitude: Double read FLongitude write SetLongitude;
    property TWLocation: TThreeWordLocation read FWs;
    property TWLocationAsStr: string read GetTWLocationAsStr;
  end;

{ TGlobalPosition }

constructor TGlobalPosition.Create(_lat, _lon: Double);
begin
  FLatitude := _lat;
  FLongitude := _lon;
  Recalculate;
end;

constructor TGlobalPosition.Create(ws: TThreeWordLocation);
begin
  Assign(ws);
end;

class function TGlobalPosition.fromWord(ws: string): int64;
begin
  Result := StrToInt(ws.Substring(1));
end;

function TGlobalPosition.GetTWLocationAsStr: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to 2 do
    Result := Result + ' ' + FWs[i];
  Result := Result.Trim;
end;

procedure TGlobalPosition.Recalculate;
var
  i: Integer;
  w: array[0..2] of int64;
  ilat, ilon, latlon: Int64;
begin
  SetLength(FWs, 3);

  // convert lat and lon to positive integers
  ilat := Round(FLatitude * 10000 + 900000);
  ilon := Round(FLongitude * 10000 + 1800000);

   // build 43 bit BigInt comprising 21 bits (lat) and 22 bits (lon)
  latlon := (ilat shl 22) + ilon;

  // isolate relevant bits
  w[0] := (latlon shr 28) and $7fff;
  w[1] := (latlon shr 14) and $3fff;
  w[2] := latlon and $3fff;

  // convert to word format
  for i := 0 to 2 do
    FWs[i] := toWord(w[i]);
end;

procedure TGlobalPosition.SetLatitude(const Value: Double);
begin
  FLatitude := Value;
  Recalculate;
end;

procedure TGlobalPosition.SetLongitude(const Value: Double);
begin
  FLongitude := Value;
  Recalculate;
end;

class function TGlobalPosition.toWord(w: int64): string;
begin
  result := format('W%.5d', [w]);
end;

procedure TGlobalPosition.Assign(Ws: TThreeWordLocation);
var
  i: Integer;
  w: array[0..2] of int64;
  ilat, ilon, latlon: Int64;
begin
  SetLength(FWs, 3);
  for i := 0 to 2 do
  begin
    FWs[i] := Ws[i];
    w[i] := fromWord(Ws[i]);
  end;

  latlon := (w[0] shl 28) or (w[1] shl 14) or w[2];
  ilat := latlon shr 22;
  ilon := latlon and $3fffff;
  FLatitude := (ilat - 900000) / 10000;
  FLongitude := (ilon - 1800000) / 10000;
end;

var
  pos: TGlobalPosition;

begin
  pos.Create(28.3852, -81.5638);

  Writeln('Starting figures:');
  Writeln(Format('  latitude = %0.4f, longitude = %0.4f', [pos.Latitude, pos.Longitude]));

  Writeln(#10'Three word location is:');
  Writeln('  ', pos.TWLocationAsStr);

  Writeln(#10'After reversing the procedure:');

  // pos.Create(['W18497','W11324','W01322']);
  pos.Create(pos.TWLocation);
  Writeln(Format('  latitude = %0.4f, longitude = %0.4f', [pos.Latitude, pos.Longitude]));

  Readln;
end.

