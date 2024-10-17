program JsonTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Json;

type
  TJsonObjectHelper = class helper for TJsonObject
  public
    class function Deserialize(data: string): TJsonObject; static;
    function Serialize: string;
  end;

{ TJsonObjectHelper }

class function TJsonObjectHelper.Deserialize(data: string): TJsonObject;
begin
  Result := TJSONObject.ParseJSONValue(data) as TJsonObject;
end;

function TJsonObjectHelper.Serialize: string;
begin
  Result := ToJson;
end;

var
  people, deserialized: TJsonObject;
  bar: TJsonArray;
  _json: string;

begin
  people := TJsonObject.Create();
  people.AddPair(TJsonPair.Create('1', 'John'));
  people.AddPair(TJsonPair.Create('2', 'Susan'));

  _json := people.Serialize;
  Writeln(_json);

  deserialized := TJSONObject.Deserialize(_json);
  Writeln(deserialized.Values['2'].Value);

  deserialized := TJSONObject.Deserialize('{"foo":1 , "bar":[10,"apples"]}');

  bar := deserialized.Values['bar'] as TJSONArray;
  Writeln(bar.Items[1].Value);

  deserialized.Free;
  people.Free;

  Readln;
end.
