Program LeastCommonMultiple(output);

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

function lcm(a, b: longint): longint;
begin
  result := a;
  while (result mod b) <> 0 do
    inc(result, a);
end;

begin
  writeln('The least common multiple of 12 and 18 is: ', lcm(12, 18));
end.
