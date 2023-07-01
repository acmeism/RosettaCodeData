program gapful;


{$IFDEF FPC}
   {$MODE DELPHI}{$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils // IntToStr
{$IFDEF FPC}
  ,strUtils // Numb2USA aka commatize
{$ENDIF};

const
  cIdx = 5;
  starts: array[0..cIdx - 1] of Uint64 = (100, 1000 * 1000, 10 * 1000 * 1000,
    1000 * 1000 * 1000, 7123);
  counts: array[0..cIdx - 1] of Uint64 = (30, 15, 15, 10, 25);
  //100|  74623687  =>    1000*1000*1000
  //100| 746236131  => 10*1000*1000*1000
  //100|7462360431  =>100*1000*1000*1000
  Base = 10;

var
  ModsHL: array[0..99] of NativeUint;
  Pow10: Uint64;    //global, seldom used
  countLmt: NativeUint; //Uint64; only for extreme counting

{$IFNDEF FPC}

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

procedure OutHeader(i: NativeInt);
begin
  writeln('First ', counts[i], ', gapful numbers starting at ', Numb2USA(IntToStr
    (starts[i])));
end;

procedure OutNum(n: Uint64);
begin
  write(' ', n);
end;

procedure InitMods(n: Uint64; H_dgt: NativeUint);
//calculate first mod of n, when it reaches n
var
  i, j: NativeInt;
begin
  j := H_dgt; //= H_dgt+i
  for i := 0 to Base - 1 do
  begin
    ModsHL[j] := n mod j;
    inc(n);
    inc(j);
  end;
end;

procedure InitMods2(n: Uint64; H_dgt, L_Dgt: NativeUint);
//calculate first mod of n, when it reaches n
//beware, that the lower n are reached in the next base round
var
  i, j: NativeInt;
begin
  j := H_dgt;
  n := n - L_Dgt;
  for i := 0 to L_Dgt - 1 do
  begin
    ModsHL[j] := (n + base) mod j;
    inc(n);
    inc(j);
  end;
  for i := L_Dgt to Base - 1 do
  begin
    ModsHL[j] := n mod j;
    inc(n);
    inc(j);
  end;
end;

procedure Main(TestNum: Uint64; Cnt: NativeUint);
var
  LmtNextNewHiDgt: Uint64;
  tmp, LowDgt, GapNum: NativeUint;
begin
  countLmt := Cnt;
  Pow10 := Base * Base;
  LmtNextNewHiDgt := Base * Pow10;
  while LmtNextNewHiDgt <= TestNum do
  begin
    Pow10 := LmtNextNewHiDgt;
    LmtNextNewHiDgt := LmtNextNewHiDgt * Base;
  end;
  LowDgt := TestNum mod Base;
  GapNum := TestNum div Pow10;
  LmtNextNewHiDgt := (GapNum + 1) * Pow10;
  GapNum := Base * GapNum;
  if LowDgt <> 0 then
    InitMods2(TestNum, GapNum, LowDgt)
  else
    InitMODS(TestNum, GapNum);

  GapNum := GapNum + LowDgt;
  repeat
//     if TestNum MOD (GapNum) = 0 then
    if ModsHL[GapNum] = 0 then
    begin
      tmp := countLmt - 1;
      if tmp < 32 then
        OutNum(TestNum);
      countLmt := tmp;
      // Test and BREAK only if something has changed
      if tmp = 0 then
        BREAK;
    end;
    tmp := Base + ModsHL[GapNum];
    //translate into "if-less" version 3.35s -> 1.85s
    //bad branch prediction :-(
    //if tmp >= GapNum then tmp -= GapNum;
    tmp := tmp - (-ORD(tmp >= GapNum) and GapNum);
    ModsHL[GapNum] := tmp;

    TestNum := TestNum + 1;
    tmp := LowDgt + 1;

    inc(GapNum);
    if tmp >= Base then
    begin
      tmp := 0;
      GapNum := GapNum - Base;
    end;
    LowDgt := tmp;
    //next Hi Digit
    if TestNum >= LmtNextNewHiDgt then
    begin
      LowDgt := 0;
      GapNum := GapNum + Base;
      LmtNextNewHiDgt := LmtNextNewHiDgt + Pow10;
      //next power of 10
      if GapNum >= Base * Base then
      begin
        Pow10 := Pow10 * Base;
        LmtNextNewHiDgt := 2 * Pow10;
        GapNum := Base;
      end;
      initMods(TestNum, GapNum);
    end;
  until false;
end;

var
  i: integer;

begin
  for i := 0 to High(starts) do
  begin
    OutHeader(i);
    Main(starts[i], counts[i]);
    writeln(#13#10);
  end;
  {$IFNDEF LINUX}  readln; {$ENDIF}
end.
