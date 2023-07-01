program RomanNumeralsDecode;

{$APPTYPE CONSOLE}

function RomanToInteger(const aRoman: string): Integer;
  function DecodeRomanDigit(aChar: Char): Integer;
  begin
    case aChar of
      'M', 'm': Result := 1000;
      'D', 'd': Result := 500;
      'C', 'c': Result := 100;
      'L', 'l': Result := 50;
      'X', 'x': Result := 10;
      'V', 'v': Result := 5;
      'I', 'i': Result := 1
    else
      Result := 0;
    end;
  end;

var
  i: Integer;
  lCurrVal: Integer;
  lLastVal: Integer;
begin
  Result := 0;

  lLastVal := 0;
  for i := Length(aRoman) downto 1 do
  begin
    lCurrVal := DecodeRomanDigit(aRoman[i]);
    if lCurrVal < lLastVal then
      Result := Result - lCurrVal
    else
      Result := Result + lCurrVal;
    lLastVal := lCurrVal;
  end;
end;

begin
  Writeln(RomanToInteger('MCMXC'));    // 1990
  Writeln(RomanToInteger('MMVIII'));   // 2008
  Writeln(RomanToInteger('MDCLXVI'));  // 1666
end.
