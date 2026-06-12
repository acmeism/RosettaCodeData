program Text_Completion;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Generics.Collections;

type
  TSujestions = TDictionary<Integer, string>;

function Levenshtein(s, t: string): integer;
var
  d: array of array of integer;
  i, j, cost: integer;
begin
  SetLength(d, Length(s) + 1);
  for i := Low(d) to High(d) do
  begin
    SetLength(d[i], Length(t) + 1);
  end;

  for i := Low(d) to High(d) do
  begin
    d[i, 0] := i;
    for j := Low(d[i]) to High(d[i]) do
    begin
      d[0, j] := j;
    end;
  end;

  for i := Low(d) + 1 to High(d) do
  begin
    for j := Low(d[i]) + 1 to High(d[i]) do
    begin
      if s[i] = t[j] then
      begin
        cost := 0;
      end
      else
      begin
        cost := 1;
      end;

      d[i, j] := Min(Min(d[i - 1, j] + 1,      //deletion
        d[i, j - 1] + 1),     //insertion
        d[i - 1, j - 1] + cost  //substitution
      );
    end;
  end;
  Result := d[Length(s), Length(t)];
end;

function FindSujestions(Search: string; dict: TStringList): TSujestions;
var
  I, ld: Integer;
  w: string;
begin
  Result := TSujestions.Create;
  for I := 0 to 3 do
    Result.Add(I, '');

  for I := 0 to dict.Count - 1 do
  begin
    w := dict[I];
    ld := Levenshtein(Search, w);
    if ld < 4 then
      Result[ld] := Result[ld] + ' ' + w;
  end;
end;

function Similarity(Search: string; Distance: Integer): Double;
var
  ALength: Double;
begin
  ALength := Search.Length;
  Result := (ALength - Distance) * 100 / ALength;
end;

var
  dict: TStringList;
  Search: string;
  i: Integer;
  Sujestions: TSujestions;

begin
  dict := TStringList.Create;
  dict.LoadFromFile('unixdict.txt');
  Search := 'complition';

  Sujestions := FindSujestions(Search, dict);

  Writeln('Input word: '#10, Search);

  for i := 1 to 3 do
  begin
    Writeln(Format('Words which are %4.1f%% similar:', [Similarity(Search, i)]));
    Writeln(sujestions[i], #10);
  end;

  Sujestions.Free;
  dict.Free;

  Readln;
end.

