program CSV_data_manipulation;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils,
  System.Types;

type
  TStringDynArrayHelper = record helper for TStringDynArray
    function Sum: Integer;
  end;

{ TStringDynArrayHelper }

function TStringDynArrayHelper.Sum: Integer;
var
  value: string;
begin
  Result := 0;
  for value in self do
    Result := Result + StrToIntDef(value, 0);
end;

const
  FILENAME = './Data.csv';

var
  i: integer;
  Input, Row: TStringDynArray;

begin
  Input := TFile.ReadAllLines(FILENAME);
  for i := 0 to High(Input) do
  begin
    if i = 0 then
      Input[i] := Input[i] + ',SUM'
    else
    begin
      Row := Input[i].Split([',']);
      Input[i] := Input[i] + ',' + row.Sum.ToString;
    end;
  end;
  TFile.WriteAllLines(FILENAME, Input);
end.
