program testthis;
{$mode objfpc}{$modeswitch functionreferences}{$modeswitch anonymousfunctions}
type
  TFuncIntResult = reference to function: Integer;

// use function that returns anonymous method to avoid capturing the loop variable
function CreateFunc(i: Integer): TFuncIntResult;
begin
  Result :=
    function: Integer
    begin
      Result := i * i;
    end;
end;

var
  Funcs: array[0..9] of TFuncIntResult;
  i: integer;
begin
  // create 10 anonymous functions
  for i := Low(Funcs) to High(Funcs) do
    Funcs[i] := CreateFunc(i);
  // call all 10 functions
  for i := Low(Funcs) to High(Funcs) do
    Writeln(Funcs[i]());
end.
