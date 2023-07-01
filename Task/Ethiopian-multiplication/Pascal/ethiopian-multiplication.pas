program EthiopianMultiplication;
  {$IFDEF FPC}
    {$MODE DELPHI}
  {$ENDIF}
  function Double(Number: Integer): Integer;
  begin
    Result := Number * 2
  end;

  function Halve(Number: Integer): Integer;
  begin
    Result := Number div 2
  end;

  function Even(Number: Integer): Boolean;
  begin
    Result := Number mod 2 = 0
  end;

  function Ethiopian(NumberA, NumberB: Integer): Integer;
  begin
    Result := 0;
    while NumberA >= 1 do
	begin
	  if not Even(NumberA) then
	    Result := Result + NumberB;
	  NumberA := Halve(NumberA);
	  NumberB := Double(NumberB)
	end
  end;

begin
  Write(Ethiopian(17, 34))
end.
