program AssociativeArrayCreation;
{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses Generics.Collections;
var
  lDictionary: TDictionary<string, Integer>;
begin
  lDictionary := TDictionary<string, Integer>.Create;
  try
    lDictionary.Add('foo', 5);
    lDictionary.Add('bar', 10);
    lDictionary.Add('baz', 15);
    lDictionary.AddOrSetValue('foo', 6); // replaces value if it exists
  finally
    lDictionary.Free;
  end;
end.
