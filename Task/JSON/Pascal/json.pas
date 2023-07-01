program test;
{$mode objfpc}{$h+}
uses
  FpJson, JsonParser;

const
  JsonValue =
    '{                            ' + LineEnding +
    '    "answer": {              ' + LineEnding +
    '        "everything": 42     ' + LineEnding +
    '    },                       ' + LineEnding +
    '    "happy": true,           ' + LineEnding +
    '    "list": [                ' + LineEnding +
    '        0,                   ' + LineEnding +
    '        1,                   ' + LineEnding +
    '        2                    ' + LineEnding +
    '    ],                       ' + LineEnding +
    '    "name": "Pierrot",       ' + LineEnding +
    '    "nothing": null,         ' + LineEnding +
    '    "object": {              ' + LineEnding +
    '        "product": "unknown",' + LineEnding +
    '        "amount": 1001       ' + LineEnding +
    '    },                       ' + LineEnding +
    '    "pi": 3.1416            ' + LineEnding +
    '}                            ';

function JsonsEqual(L, R: TJsonData): Boolean;
var
  I: Integer;
  e: TJsonEnum;
  d: TJsonData;
begin
  if (L = nil) or (R = nil) then exit(False);
  if L = R then exit(True);
  if (L.JSONType <> R.JSONType) or (L.Count <> R.Count) then exit(False);
  case L.JSONType of
    jtUnknown: exit(False);
    jtNull:    ;
    jtBoolean: exit(L.AsBoolean = R.AsBoolean);
    jtNumber:  exit(L.AsFloat = R.AsFloat);
    jtString:  exit(L.AsString = R.AsString);
    jtArray:
      for I := 0 to Pred(L.Count) do
        if not JsonsEqual(L.Items[I], R.Items[I]) then exit(False);
    jtObject:
      for e in L do begin
        if not TJsonObject(R).Find(e.Key, d) then exit(False);
        if not JsonsEqual(e.Value, d) then exit(False);
      end;
  end;
  Result := True;
end;

var
  Expected, HandMade: TJsonData;

begin
  Expected := GetJson(JsonValue);
  HandMade := CreateJSONObject([
    'answer', CreateJSONObject(['everything', 42]),
    'happy', True,
    'list', CreateJSONArray([0, 1, 2]),
    'name', 'Pierrot',
    'nothing', CreateJSON,
    'object', CreateJSONObject(['product', 'unknown', 'amount', 1001]),
    'pi', 3.1416
  ]);
  WriteLn(HandMade.FormatJson);
  WriteLn;
  if JsonsEqual(Expected, HandMade) then
    WriteLn('Objects look identical')
  else
    WriteLn('Oops, something went wrong');
  Expected.Free;
  HandMade.Free;
end.
