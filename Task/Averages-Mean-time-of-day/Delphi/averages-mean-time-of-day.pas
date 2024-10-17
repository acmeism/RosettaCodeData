program Averages_Mean_time_of_day;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

const
  Inputs: TArray<string> = ['23:00:17', '23:40:20', '00:12:45', '00:17:19'];

function ToTimes(ts: TArray<string>): TArray<TTime>;
begin
  SetLength(result, length(ts));
  for var i := 0 to High(ts) do
    Result[i] := StrToTime(ts[i]);
end;

function MeanTime(times: TArray<TTime>): TTime;
var
  ssum, csum: TTime;
  h, m, s, ms: word;
  dayFrac, fsec, ssin, ccos: double;
begin
  if Length(times) = 0 then
    exit(0);

  ssum := 0;
  csum := 0;
  for var t in times do
  begin
    DecodeTime(t, h, m, s, ms);
    fsec := (h * 60 + m) * 60 + s + ms / 1000;
    ssin := sin(fsec * Pi / (12 * 60 * 60));
    ccos := cos(fsec * Pi / (12 * 60 * 60));
    ssum := ssum + ssin;
    csum := csum + ccos;
  end;
  if (ssum = 0) and (csum = 0) then
    raise Exception.Create('Error MeanTime: Mean undefined');

  dayFrac := frac(1 + ArcTan2(ssum, csum) / (2 * Pi));
  fsec := dayFrac * 24 * 3600;

  ms := Trunc(frac(fsec) * 1000);
  s := trunc(fsec) mod 60;
  m := trunc(fsec) div 60 mod 60;
  h := trunc(fsec) div 3600;

  Result := EncodeTime(h, m, s, ms);
end;

begin
  writeln(TimeToStr(MeanTime(ToTimes(Inputs))));
  readln;
end.
