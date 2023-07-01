program CombWithRep;
//combinations with repetitions
//Limit = count of elements
//Maxval = value of top , lowest is always 0
//so 0..Maxvalue => maxValue+1 elements
{$IFDEF FPC}
//  {$R+,O+}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$COPERATORS ON}
{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  SysUtils;//GetTickCount64

var
  CombIdx: array of byte;

  function InitCombIdx(ElemCount: Int32): pbyte;
  begin
    setlength(CombIdx, ElemCount + 1);
    Fillchar(CombIdx[0], sizeOf(CombIdx[0]) * (ElemCount + 1), #0);
    Result := @CombIdx[0];
  end;

  function NextCombWithRep(pComb: pByte; MaxVal, ElemCount: UInt32): boolean;
  var
    i, dgt: NativeInt;
  begin
    i := -1;
    repeat
      i += 1;
      dgt := pComb[i];
      if dgt < MaxVal then
        break;
    until i > ElemCount;
    Result := i >= ElemCount;
    dgt +=1;
    repeat
      pComb[i] := dgt;
      i -= 1;
    until i < 0;
  end;

  procedure GetDoughnuts(ElemCount: NativeInt);
  const
    doughnuts: array[0..2] of string = ('iced', 'jam', 'plain');
  var
    pComb: pByte;
    MaxVal, i: Uint32;
  begin
    if ElemCount < 1 then
      EXIT;
    MaxVal := High(doughnuts);
    writeln('Getting ', ElemCount, ' elements of ', MaxVal + 1, ' different');
    pComb := InitCombIdx(ElemCount);
    repeat
      Write('[');
      for i := 0 to ElemCount - 2 do
        Write(pComb[i], ',');
      Write(pComb[ElemCount - 1], ']');
      Write('{');
      for i := 0 to ElemCount - 2 do
        Write(doughnuts[pComb[i]], ',');
      Write(doughnuts[pComb[ElemCount - 1]], '}');
    until NextCombWithRep(pComb, MaxVal, ElemCount);
    writeln(#10);
  end;

  procedure Check(ElemCount: Int32; ElemRange: Uint32);
  var
    pComb: pByte;
    T0: int64;
    rec_cnt: NativeInt;
  begin
    T0 := GetTickCount64;
    rec_cnt := 0;
    ElemRange -= 1;
    pComb := InitCombIdx(ElemCount);
    repeat
      Inc(rec_cnt);
    until NextCombWithRep(pComb, ElemRange, ElemCount);
    T0 := GetTickCount64 - T0;
    writeln('Getting ', ElemCount, ' elements of ', ElemRange + 1, ' different');
    writeln(rec_cnt: 10, t0: 10,' ms');
  end;

begin
  GetDoughnuts(2);
  GetDoughnuts(3);
  Check(3, 10);
  Check(9, 10);
  Check(15, 16);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
