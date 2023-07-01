program Power2FirstDigits;

uses
  sysutils,
  strUtils;

const
{$IFDEF FPC}
  {$MODE DELPHI}

  ld10 :double = ln(2)/ln(10);// thats 1/log2(10)
{$ELSE}
  ld10 = 0.30102999566398119521373889472449;

function Numb2USA(const S: string): string;
var
  i, NA: Integer;
begin
  i := Length(S);
  Result := S;
  NA := 0;
  while (i > 0) do
  begin
    if ((Length(Result) - i + 1 - NA) mod 3 = 0) and (i <> 1) then
    begin
      insert(',', Result, i);
      inc(NA);
    end;
    Dec(i);
  end;
end;

{$ENDIF}

function FindExp(CntLmt, Number: NativeUint): NativeUint;
var
  i, cnt, DgtShift: NativeUInt;
begin
  //calc how many Digits needed
  i := Number;
  DgtShift := 1;
  while i >= 10 do
  begin
    DgtShift := DgtShift * 10;
    i := i div 10;
  end;

  cnt := 0;
  i := 0;
  repeat
    inc(i);
    // x= i*ld10 -> 2^I = 10^x
    // 10^frac(x) -> [0..10[ = exp(ln(10)*frac(i*lD10))
    if Trunc(DgtShift * exp(ln(10) * frac(i * lD10))) = Number then
    begin
      inc(cnt);
      if cnt >= CntLmt then
        BREAK;
    end;
  until false;
  write('The  ', Numb2USA(IntToStr(cnt)), 'th  occurrence of 2 raised to a power');
  write(' whose product starts with "', Numb2USA(IntToStr(Number)));
  writeln('" is ', Numb2USA(IntToStr(i)));
  FindExp := i;
end;

begin
  FindExp(1, 12);
  FindExp(2, 12);

  FindExp(45, 123);
  FindExp(12345, 123);
  FindExp(678910, 123);
end.
