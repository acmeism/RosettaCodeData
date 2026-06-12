program PowerOwnDigits2;
{$IFDEF FPC}
  {$R+,O+}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils,StrUtils;
const
  CPU_hz = 1000*1000*1000;
const
  MAXBASE = 10;
  MaxDgtVal = MAXBASE - 1;
  MaxDgtCount = 19;
type
  tDgtCnt = 0..MaxDgtCount;
  tValues = 0..MaxDgtVal;
  tUsedDigits = array[tValues] of Int8;
  tpUsedDigits = ^tUsedDigits;

  tPower = array[tValues] of Uint64;
var
  PowerDgt:  tPower;
  gblUD   : tUsedDigits;
  CombIdx : array of Int8;
  Numbers : array of Uint64;
  rec_cnt : NativeInt;

 function GetCPU_Time: Uint64;
  type
    TCpu = record
              HiCpu,
              LoCpu : Dword;
           end;
  var
    Cput : TCpu;
  begin
  {$ASMMODE INTEL}
    asm
    RDTSC;
    MOV Dword Ptr [CpuT.LoCpu],EAX;  MOV Dword Ptr [CpuT.HiCpu],EDX
    end;
    with Cput do  result := Uint64(HiCPU) shl 32 + LoCpu;
  end;

  function InitCombIdx(ElemCount: Byte): pbyte;
  begin
    setlength(CombIdx, ElemCount + 1);
    Fillchar(CombIdx[0], sizeOf(CombIdx[0]) * (ElemCount + 1), #0);
    Result := @CombIdx[0];
    Fillchar(gblUD[0], sizeOf(tUsedDigits), #0);
    gblUD[0]:= 1;
  end;

  function Init(ElemCount:byte;Expo:byte):pByte;
  var
    pP1 : pUint64;
    p: Uint64;
    i,j: Int32;
  begin
    pP1 := @PowerDgt[0];
    for i in tValues do
    Begin
      p := 1;
      for j := 1 to Expo do
        p *= i;
      pP1[i] := p;
    end;
    result := InitCombIdx(ElemCount);
    gblUD[0]:= 1;
  end;

  function GetPowerSum(minpot:nativeInt;digits:pbyte;var UD :tUsedDigits):NativeInt;
  var
    res,r  : Uint64;
    dgt :Int32;
  begin
    dgt := minpot;
    res := 0;
    repeat
      dgt -=1;
      res += PowerDgt[digits[dgt]];
    until dgt=0;
    result := 0;
    //convert res into digits
    repeat
      r := res DIV MAXBASE;
      result+=1;
      dgt := res-r*MAXBASE;
      //substract from used digits
      UD[dgt] -= 1;
      res := r;
    until r = 0;
  end;

  procedure calcNum(minPot:Int32;digits:pbyte);
  var
    UD :tUsedDigits;
    res: Uint64;
    i: nativeInt;
  begin
    UD := gblUD;
    i:= GetPowerSum(minpot,digits,UD);
    if i = minPot then
    Begin
      //don't check 0
      i := 1;
      repeat
        If UD[i] <> 0 then
          Break;
        i +=1;
      until i > MaxDgtVal;

      if i > MaxDgtVal then
      begin
        res := 0;
        for i := minpot-1 downto 0 do
          res += PowerDgt[digits[i]];
        setlength(Numbers, Length(Numbers) + 1);
        Numbers[high(Numbers)] := res;
      end;
    end;
  end;

  function NextCombWithRep(pComb: pByte;pUD :tpUsedDigits;MaxVal, ElemCount: UInt32): boolean;
  var
    i,dgt: NativeInt;
  begin
    i := -1;
    repeat
      i += 1;
      dgt := pComb[i];
      if dgt < MaxVal then
        break;
      dec(pUD^[dgt]);
    until i >= ElemCount;
    Result := i >= ElemCount;

    if i = 0 then
    begin
      dec(pUD^[dgt]);
      dgt +=1;
      pComb[i] := dgt;
      inc(pUD^[dgt]);
    end
    else
    begin
      dec(pUD^[dgt]);
      dgt +=1;
      pUD^[dgt]:=i+1;
      repeat
        pComb[i] := dgt;
        i -= 1;
      until i < 0;
    end;
  end;

var
  digits : pByte;
  T0,T1 : UInt64;
  tmp : Uint64;
  Pot,dgtCnt,i, j : Int32;

begin
  T0 := GetCPU_Time;
  For pot := 2 to MaxDgtCount do
  begin
    Write('Exponent : ',Pot,' used ');
    T1 := GetCPU_Time;
    digits := Init(MaxDgtCount,pot);
    rec_cnt := 0;
    // i > 0
    For dgtCnt := 2 to pot+1 do
    Begin
      digits := InitCombIdx(Pot);
      repeat
        calcnum(dgtCnt,digits);
        inc(rec_cnt);
      until NextCombWithRep(digits,@gblUD,MaxDgtVal,dgtCnt);
    end;
    writeln(rec_cnt,' recursions in ',(GetCPU_Time-T1)/CPU_hz:0:6,' GigaCyles');
    If length(numbers) > 0 then
    Begin
      //sort
      for i := 0 to High(Numbers) - 1 do
        for j := i + 1 to High(Numbers) do
          if Numbers[j] < Numbers[i] then
          begin
            tmp := Numbers[i];
            Numbers[i] := Numbers[j];
            Numbers[j] := tmp;
          end;

      tmp := 0;
      for i := 0 to High(Numbers)-1 do
      begin
        write(Numb2USA(IntToStr(Numbers[i])),' + ');
        tmp +=Numbers[i];
      end;
      write(Numb2USA(IntToStr(Numbers[High(Numbers)])),' = ');
      tmp +=Numbers[High(Numbers)];
      writeln('sum to ',Numb2USA(IntToStr(tmp)));
    end;
    writeln;
    setlength(Numbers,0);
  end;
  T0 := GetCPU_Time-T0;
  Writeln('Max Uint64 ',Numb2USA(IntToStr(High(Uint64))));
  writeln('Total runtime : ',T0/CPU_hz:0:6,' GigaCyles');
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
  setlength(CombIdx,0);
end.
