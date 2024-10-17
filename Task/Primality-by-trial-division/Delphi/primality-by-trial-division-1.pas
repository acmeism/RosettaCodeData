function IsPrime(aNumber: Integer): Boolean;
var
  I: Integer;
begin
  Result:= True;
  if(aNumber = 2) then Exit;

  Result:= not ((aNumber mod 2 = 0)  or
                (aNumber <= 1));
  if not Result then Exit;

  for I:=3 to Trunc(Sqrt(aNumber)) do
  if(aNumber mod I = 0) then
  begin
    Result:= False;
    Break;
  end;
end;
