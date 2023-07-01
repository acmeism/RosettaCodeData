program Levenshtein_distanceTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Math;

function Levenshtein_distance(s, t: string): integer;
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

procedure Println(s, t: string);
begin
  Writeln('> LevenshteinDistance "', s, '" "', t, '"');
  Writeln(s, ' -> ', t, ' = ', Levenshtein_distance(s, t), #10);
end;

begin
  Println('kitten', 'sitting');
  Println('rosettacode', 'raisethysword');
  readln;
end.
