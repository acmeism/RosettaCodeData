function IsNumericString(const inStr: string): Boolean;
var
  i: extended;
begin
  Result := TryStrToFloat(inStr,i);
end;
