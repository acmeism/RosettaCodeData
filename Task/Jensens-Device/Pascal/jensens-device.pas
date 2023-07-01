program Jensens_Device;

{$IFDEF FPC}
  {$MODE objFPC}
{$ENDIF}

type
  tTerm = function(i: integer): real;

function term(i: integer): real;
begin
  term := 1 / i;
end;

function sum(var i: LongInt; lo, hi: integer; term: tTerm): real;
begin
  result := 0;
  i := lo;
  while i <= hi do
  begin
    result := result + term(i);
    inc(i);
  end;
end;

var
  i: LongInt;

begin
  writeln(sum(i, 1, 100, @term));
  {$IFNDEF UNIX}  readln; {$ENDIF}
end.
