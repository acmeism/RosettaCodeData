program AssociativeArrayCreation;
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
{$MODE DELPHI}
uses fgl;

var
  lDictionary: TFPGMap<string, Integer>;
begin
  lDictionary := TFPGMap<string, Integer>.Create;
  try
    lDictionary.Add('foo', 5);
    lDictionary.Add('bar', 10);
    lDictionary.Add('baz', 15);
  finally
    lDictionary.Free;
  end;
end.
