program Power2Digits;
uses
  sysutils,strUtils;
const
  L_float64 = sqr(sqr(65536.0));//2**64
  Log10_2_64 = TRUNC(L_float64*ln(2)/ln(10));

function FindExp(CntLmt,Number:NativeUint):NativeUint;
var
  Log10Num : extended;
  LmtUpper,LmtLower : UInt64;
  Frac64 : UInt64;
  i,dgts,cnt: NativeUInt;
begin
  i := Number;
  dgts := 1;
  while i >= 10 do
  Begin
    dgts *= 10;
    i := i div 10;
  end;
  //trunc is Int64 :-( so '316' was a limit
  Log10Num :=ln((Number+1)/dgts)/ln(10);
  IF Log10Num >= 0.5 then
  Begin
    IF (Number+1)/dgts < 10 then
    Begin
      LmtUpper := Trunc(Log10Num*(L_float64*0.5))*2;
      LmtUpper += Trunc(Log10Num*2);
    end
    else
      LmtUpper := 0;
    Log10Num :=ln(Number/dgts)/ln(10);
    LmtLower := Trunc(Log10Num*(L_float64*0.5))*2;
    LmtLower += Trunc(Log10Num*2);
  end
  Else
  Begin
    LmtUpper := Trunc(Log10Num*L_float64);
    LmtLower := Trunc(ln(Number/dgts)/ln(10)*L_float64);
  end;

  cnt := 0;
  i := 0;
  Frac64 := 0;
  IF LmtUpper <> 0 then
  Begin
    repeat
      inc(i);
      inc(Frac64,Log10_2_64);
      IF (Frac64>= LmtLower) AND (Frac64< LmtUpper) then
      Begin
        inc(cnt);
        IF cnt>= CntLmt then
          BREAK;
      end;
    until false
  end
  Else
  //searching for '999..'
  Begin
    repeat
      inc(i);
      inc(Frac64,Log10_2_64);
      IF (Frac64>= LmtLower) then
      Begin
        inc(cnt);
        IF cnt>= CntLmt then
          BREAK;
      end;
    until false
  end;
  write('The ',Numb2USA(IntToStr(cnt)),'th  occurrence of 2 raised to a power');
  write(' whose product starts with "',Numb2USA(IntToStr(number)));
  writeln('" is ',Numb2USA(IntToStr(i)));
  FindExp := i;
end;

Begin
  FindExp(1,12);
  FindExp(2,12);

  FindExp(45,223);
  FindExp(12345,123);
  FindExp(678910,123);

  FindExp(1,99);
end.
