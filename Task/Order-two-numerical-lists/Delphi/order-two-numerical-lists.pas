program Order_two_numerical_lists;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Defaults;

type
  TArray = record
    class function LessOrEqual<T>(first, second: TArray<T>): Boolean; static;
  end;

class function TArray.LessOrEqual<T>(first, second: TArray<T>): Boolean;
begin
  if Length(first) = 0 then
    exit(true);
  if Length(second) = 0 then
    exit(false);
  var comp := TComparer<T>.Default.Compare(first[0], second[0]);
  if comp = 0 then
    exit(LessOrEqual(copy(first, 1, length(first)), copy(second, 1, length(second))));
  Result := comp < 0;
end;

begin
  writeln(TArray.LessOrEqual<Integer>([1, 2, 3], [2, 3, 4]));
  writeln(TArray.LessOrEqual<Integer>([2, 3, 4], [1, 2, 3]));
  writeln(TArray.LessOrEqual<Integer>([1, 2], [1, 2, 3]));
  writeln(TArray.LessOrEqual<Integer>([1, 2, 3], [1, 2]));
  writeln(TArray.LessOrEqual<Char>(['a', 'c', 'b'], ['a', 'b', 'b']));
  writeln(TArray.LessOrEqual<string>(['this', 'is', 'a', 'test'], ['this', 'is',
    'not', 'a', 'test']));
  readln;
end.
