program ShortCircuitEvaluation;

{$APPTYPE CONSOLE}

uses SysUtils;

function A(aValue: Boolean): Boolean;
begin
  Writeln('a');
  Result := aValue;
end;

function B(aValue: Boolean): Boolean;
begin
  Writeln('b');
  Result := aValue;
end;

var
  i, j: Boolean;
begin
  for i in [False, True] do
  begin
    for j in [False, True] do
    begin
      Writeln(Format('%s and %s = %s', [BoolToStr(i, True), BoolToStr(j, True), BoolToStr(A(i) and B(j), True)]));
      Writeln;
      Writeln(Format('%s or %s = %s', [BoolToStr(i, True), BoolToStr(j, True), BoolToStr(A(i) or B(j), True)]));
      Writeln;
    end;
  end;
end.
