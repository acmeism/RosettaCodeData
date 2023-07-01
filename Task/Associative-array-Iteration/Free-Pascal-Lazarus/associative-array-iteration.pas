program AssociativeArrayIteration;
{$mode delphi}{$ifdef windows}{$apptype console}{$endif}
uses Generics.Collections;

type
  TlDictionary =  TDictionary<string, Integer>;
  TlPair = TPair<string,integer>;

var
  i: Integer;
  s: string;
  lDictionary: TlDictionary;
  lPair: TlPair;
begin
  lDictionary := TlDictionary.Create;
  try
    lDictionary.Add('foo', 5);
    lDictionary.Add('bar', 10);
    lDictionary.Add('baz', 15);
    lDictionary.AddOrSetValue('foo',6);
    for lPair in lDictionary do
      Writeln('Pair: ',Lpair.Key,' = ',lPair.Value);
    for s in lDictionary.Keys do
      Writeln('Key: ' + s);
    for i in lDictionary.Values do
      Writeln('Value: ', i);
  finally
    lDictionary.Free;
  end;
end.
