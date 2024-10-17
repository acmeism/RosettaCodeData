program AveragesMode;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

type
  TCounts = TDictionary<Integer, Integer>;

  TPair = record
    value, count: Integer;
    constructor Create(value, count: Integer);
  end;

  TPairs = TArray<TPair>;

var
  dict: TCounts;
  Pairs: TPairs;
  list: TArray<Integer>;
  i, key, max: Integer;
  p: TPair;

{ TPair }

constructor TPair.Create(value, count: Integer);
begin
  self.value := value;
  self.count := count;
end;

function SortByCount(const left, right: TPair): Integer;
begin
  Result := right.count - left.count;
end;

begin
  list := [1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 12, 12, 17];
  dict := TCounts.Create;

  for i in list do
  begin
    if dict.ContainsKey(i) then
      dict[i] := dict[i] + 1
    else
    begin
      dict.Add(i, 1);
    end;
  end;

  SetLength(Pairs, dict.Count);
  i := 0;
  for key in dict.Keys do
  begin
    Pairs[i] := TPair.Create(key, dict[key]);
    inc(i);
  end;

  TArray.Sort<TPair>(Pairs, TComparer<TPair>.Construct(SortByCount));

  Writeln('Modes:');
  max := Pairs[0].count;
  for p in Pairs do
    if p.count = max then
      Writeln('   Value: ', p.value, ', Count: ', p.count);

  dict.Free;
  Readln;
end.
