program Associative_arrayMerging;

{$APPTYPE CONSOLE}

uses
  System.Generics.Collections;

type
  TData = TDictionary<string, Variant>;

var
  baseData, updateData, mergedData: TData;
  entry: string;

begin
  baseData := TData.Create();
  baseData.Add('name', 'Rocket Skates');
  baseData.Add('price', 12.75);
  baseData.Add('color', 'yellow');

  updateData := TData.Create();
  updateData.Add('price', 15.25);
  updateData.Add('color', 'red');
  updateData.Add('year', 1974);

  mergedData := TData.Create();
  for entry in baseData.Keys do
    mergedData.AddOrSetValue(entry, baseData[entry]);

  for entry in updateData.Keys do
    mergedData.AddOrSetValue(entry, updateData[entry]);

  for entry in mergedData.Keys do
    Writeln(entry, ' ', mergedData[entry]);

  mergedData.Free;
  updateData.Free;
  baseData.Free;

  Readln;
end.
