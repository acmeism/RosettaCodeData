program SortWithCustomComparator;

{$APPTYPE CONSOLE}

uses SysUtils, Types, Generics.Collections, Generics.Defaults;

var
  lArray: TStringDynArray;
begin
  lArray := TStringDynArray.Create('Here', 'are', 'some', 'sample', 'strings', 'to', 'be', 'sorted');

  TArray.Sort<string>(lArray , TDelegatedComparer<string>.Construct(
  function(const Left, Right: string): Integer
  begin
    //Returns ('Here', 'are', 'be', 'sample', 'some', 'sorted', 'strings', 'to')
    //Result := CompareStr(Left, Right);

    //Returns ('are', 'be', 'Here', 'sample', 'some', 'sorted', 'strings', 'to')
    Result := CompareText(Left, Right);
  end));
end.
