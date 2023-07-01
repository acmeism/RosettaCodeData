program Hash_from_two_arrays;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  THash = TDictionary<string, Integer>;

  THashHelper = class helper for THash
    procedure AddItems(keys: TArray<string>; values: TArray<Integer>);
  end;

{ THashHelper }

procedure THashHelper.AddItems(keys: TArray<string>; values: TArray<Integer>);
var
  i: Integer;
begin
  Assert(length(keys) = Length(values), 'Keys and values, must have the same size.');
  for i := 0 to High(keys) do
    AddOrSetValue(keys[i], values[i]);
end;

var
  hash: TDictionary<string, Integer>;
  i: integer;
  key: string;

begin
  hash := TDictionary<string, Integer>.Create();
  hash.AddItems(['a', 'b', 'c'], [1, 2, 3]);

  for key in hash.Keys do
    Writeln(key, '   ', hash[key]);

  hash.Free;

  readln;
end.
