program AssociativeArrayIteration;

{$APPTYPE CONSOLE}

uses SysUtils, Generics.Collections;

var
  i: Integer;
  s: string;
  lDictionary: TDictionary<string, Integer>;
  lPair: TPair<string, Integer>;
begin
  lDictionary := TDictionary<string, Integer>.Create;
  try
    lDictionary.Add('foo', 5);
    lDictionary.Add('bar', 10);
    lDictionary.Add('baz', 15);
    lDictionary.AddOrSetValue('foo', 6);

    for lPair in lDictionary do
      Writeln(Format('Pair: %s = %d', [lPair.Key, lPair.Value]));
    for s in lDictionary.Keys do
      Writeln('Key: ' + s);
    for i in lDictionary.Values do
      Writeln('Value: ', i);
  finally
    lDictionary.Free;
  end;
end.
