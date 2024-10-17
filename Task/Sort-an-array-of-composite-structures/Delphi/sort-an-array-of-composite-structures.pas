program SortCompositeStructures;

{$APPTYPE CONSOLE}

uses SysUtils, Generics.Collections, Generics.Defaults;

type
  TStructurePair = record
    name: string;
    value: string;
    constructor Create(const aName, aValue: string);
  end;

constructor TStructurePair.Create(const aName, aValue: string);
begin
  name := aName;
  value := aValue;
end;

var
  lArray: array of TStructurePair;
begin
  SetLength(lArray, 3);
  lArray[0] := TStructurePair.Create('dog', 'rex');
  lArray[1] := TStructurePair.Create('cat', 'simba');
  lArray[2] := TStructurePair.Create('horse', 'trigger');

  TArray.Sort<TStructurePair>(lArray , TDelegatedComparer<TStructurePair>.Construct(
  function(const Left, Right: TStructurePair): Integer
  begin
    Result := CompareText(Left.Name, Right.Name);
  end));
end.
