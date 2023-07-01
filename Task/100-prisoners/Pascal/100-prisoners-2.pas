program Prisoners100;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
type
  tValue  = NativeUint;
  tpValue = pNativeUint;
  tPrisNum = array of tValue;

const
  rounds  = 1000000;
  cAlreadySeen = High(tValue);
var
  drawers,
  Visited,
  CntToPardoned : tPrisNum;
  PrisCount : NativeInt;

procedure shuffle(var N:tPrisNum;lmt : nativeInt = 0);
var
  pN : tpValue;
  i,j : nativeInt;
  tmp: tValue;
Begin
  pN := @N[0];
  if lmt = 0 then
    lmt := High(N);
  For i := lmt downto 1 do
  begin
    //take one from index [0..i]
    j := random(i+1);
    //exchange with i
    tmp := pN[i];pN[i]:= pN[j];pN[j]:= tmp;
  end;
end;

procedure CopyDrawers2Visited;
//drawers and Visited are of same size, so only moving values
Begin
  Move(drawers[0],Visited[0],SizeOf(tValue)*PrisCount);
end;

function GetMaxCycleLen:NativeUint;
var
  pVisited : tpValue;
  cycleLen,MaxCycLen,Num,NumBefore : NativeUInt;
Begin
  CopyDrawers2Visited;
  pVisited := @Visited[0];
  MaxCycLen := 0;
  cycleLen := MaxCycLen;
  Num := MaxCycLen;
  repeat
    NumBefore := Num;
    Num := pVisited[Num];
    pVisited[NumBefore] := cAlreadySeen;
    inc(cycleLen);
    IF (Num= NumBefore) or (Num = cAlreadySeen) then
    begin
      IF Num = cAlreadySeen then
        dec(CycleLen);
      IF MaxCycLen < cycleLen then
        MaxCycLen := cycleLen;
      Num := 0;
      while (Num< PrisCount) AND (pVisited[Num] = cAlreadySeen) do
        inc(Num);
      //all cycles found
      IF Num >= PrisCount then
        BREAK;
      cycleLen :=0;
    end;
  until false;
  GetMaxCycleLen := MaxCycLen-1;
end;

procedure CheckOptimized(testCount : NativeUint);
var
  factor: extended;
  i,sum,digit,delta : NativeInt;
Begin
  For i := 1 to rounds do
  begin
    shuffle(drawers);
    inc(CntToPardoned[GetMaxCycleLen]);
  end;

  digit := 0;
  sum := rounds;
  while sum > 100 do
  Begin
    inc(digit);
    sum := sum DIV 10;
  end;
  factor := 100.0/rounds;

  delta :=0;
  sum := 0;
  For i := 0 to High(drawers) do
  Begin
    inc(sum,CntToPardoned[i]);
    dec(delta);
    IF delta <= 0 then
    Begin
      writeln(sum*factor:Digit+5:Digit,'% get pardoned checking max ',i+1);
      delta := delta+Length(drawers) DIV 10;
    end;
  end;
end;

procedure OneCompareRun(PrisCnt:NativeInt);
var
  i,lmt :nativeInt;
begin
  PrisCount := PrisCnt;
  setlength(drawers,PrisCnt);
  For i := 0 to PrisCnt-1 do
    drawers[i] := i;
  setlength(Visited,PrisCnt);
  setlength(CntToPardoned,PrisCnt);
  //test
  writeln('Checking ',PrisCnt,' prisoners for ',rounds,' rounds');
  lmt := PrisCnt;
  CheckOptimized(lmt);
  writeln;

  setlength(CntToPardoned,0);
  setlength(Visited,0);
  setlength(drawers,0);
end;

Begin
  randomize;
  OneCompareRun(10);
  OneCompareRun(100);
  OneCompareRun(1000);
end.
