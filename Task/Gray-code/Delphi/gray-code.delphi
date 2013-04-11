program GrayCode;

{$APPTYPE CONSOLE}

uses SysUtils;

function Encode(v: Integer): Integer;
begin
  Result := v xor (v shr 1);
end;

function Decode(v: Integer): Integer;
begin
  Result := 0;
  while v > 0 do
  begin
    Result := Result xor v;
    v := v shr 1;
  end;
end;

function IntToBin(aValue: LongInt; aDigits: Integer): string;
begin
  Result := StringOfChar('0', aDigits);
  while aValue > 0 do
  begin
    if (aValue and 1) = 1 then
      Result[aDigits] := '1';
    Dec(aDigits);
    aValue := aValue shr 1;
  end;
end;

var
  i, g, d: Integer;
begin
  Writeln('decimal  binary   gray    decoded');

  for i := 0 to 31 do
  begin
    g := Encode(i);
    d := Decode(g);
    Writeln(Format('  %2d     %s   %s   %s  %2d', [i, IntToBin(i, 5), IntToBin(g, 5), IntToBin(d, 5), d]));
  end;
end.
