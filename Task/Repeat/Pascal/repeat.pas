program Repeater;

type
  TProc = procedure(I: Integer);

procedure P(I: Integer);
begin
  WriteLn('Iteration ', I);
end;

procedure Iterate(P: TProc; N: Integer);
var
  I: Integer;
begin
  for I := 1 to N do
    P(I);
end;

begin
  Iterate(P, 3);
end.
