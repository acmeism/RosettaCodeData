program JortSort;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults;

type
  TArrayHelper = class helper for TArray
  public
    class function JortSort<T>(const original: TArray<T>): Boolean; static;
  end;

{ TArrayHelper }

class function TArrayHelper.JortSort<T>(const original: TArray<T>): Boolean;
var
  sorted: TArray<T>;
  i: Integer;
begin
  SetLength(sorted, Length(original));
  copy<T>(original, sorted, Length(original));
  Sort<T>(sorted);

  for i := 0 to High(original) do
    if TComparer<T>.Default.Compare(sorted[i], original[i]) <> 0 then
      exit(False);
  Result := True;
end;

var
  test: TArray<Integer>;
begin
  // true
  test := [1, 2, 3, 4, 5];
  Writeln(TArray.JortSort<Integer>(test));

  // false
  test := [5, 4, 3, 2, 1];
  Writeln(TArray.JortSort<Integer>(test));

  Readln;
end.
