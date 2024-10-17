program Write_float_arrays_to_a_text_file;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils;

function ToString(v: TArray<Double>): TArray<string>;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create('en-US');
  SetLength(Result, length(v));

  for var i := 0 to High(v) do
    Result[i] := v[i].tostring(ffGeneral, 5, 3, fmt);
end;

function Merge(a, b: TArray<string>): TArray<string>;
begin
  SetLength(Result, length(a));
  for var i := 0 to High(a) do
    Result[i] := a[i] + ^I + b[i];
end;

var
  x, y: TArray<Double>;

begin
  x := [1, 2, 3, 1e11];
  y := [1, 1.4142135623730951, 1.7320508075688772, 316227.76601683791];

  TFile.WriteAllLines('FloatArrayColumns.txt', Merge(ToString(x), ToString(y)));
end.
