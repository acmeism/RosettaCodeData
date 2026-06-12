program Longest_common_suffix;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Types;

type
  TStringDynArrayHelper = record helper for TStringDynArray
  private
    class function Compare(const s: string; a: TStringDynArray; subSize: integer):
      Boolean;
  public
    function Reverse(value: string): string;
    function LongestSuffix: string;
    function Join(const sep: char): string;
  end;

{ TStringDynArrayHelper }

class function TStringDynArrayHelper.Compare(const s: string; a: TStringDynArray;
  subSize: integer): Boolean;
var
  i: Integer;
begin
  for i := 0 to High(a) do
    if s <> a[i].Substring(0, subSize) then
      exit(False);
  Result := True;
end;

function TStringDynArrayHelper.Join(const sep: char): string;
begin
  Result := string.Join(sep, self);
end;

function TStringDynArrayHelper.LongestSuffix: string;
var
  ALength: Integer;
  i, lenMin, longest: Integer;
  ref: string;
begin
  ALength := Length(self);

  // Empty list
  if ALength = 0 then
    exit('');

  lenMin := MaxInt;
  for i := 0 to ALength - 1 do
  begin
    // One string is empty
    if self[i].IsEmpty then
      exit('');

    self[i] := Reverse(self[i]);

    // Get the minimum length of string
    if lenMin > self[i].Length then
      lenMin := self[i].Length;
  end;

  longest := -1;
  repeat
    inc(longest);
    ref := self[0].Substring(0, longest + 1);
  until not compare(ref, Self, longest + 1) or (longest >= lenMin);

  Result := self[0].Substring(0, longest);
  Result := reverse(Result);
end;

function TStringDynArrayHelper.Reverse(value: string): string;
var
  ALength: Integer;
  i: Integer;
  c: Char;
begin
  ALength := value.Length;
  Result := value;

  if ALength < 2 then
    exit;

  for i := 1 to ALength div 2 do
  begin
    c := Result[i];
    Result[i] := Result[ALength - i + 1];
    Result[ALength - i + 1] := c;
  end;
end;

var
  List: TStringDynArray;

begin
  List := ['baabababc', 'baabc', 'bbbabc'];

  Writeln('Input:');
  Writeln(List.Join(#10), #10);
  Writeln('Longest common suffix = ', List.LongestSuffix);

  Readln;
end.

