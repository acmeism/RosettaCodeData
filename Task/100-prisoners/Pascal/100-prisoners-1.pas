program Prisoners100;

const
  rounds  = 100000;

type
  tValue = Uint32;
  tPrisNum = array of tValue;
var
  drawers,
  PrisonersChoice : tPrisNum;

procedure shuffle(var N:tPrisNum);
var
  i,j,lmt : nativeInt;
  tmp: tValue;
Begin
  lmt := High(N);
  For i := lmt downto 1 do
  begin
    //take on from index i..limit
    j := random(i+1);
    //exchange with i
    tmp := N[i];N[i]:= N[j];N[j]:= tmp;
  end;
end;

function PardonedRandom(maxTestNum: NativeInt):boolean;
var
  PrisNum,TestNum,Lmt : NativeUint;
  Pardoned : boolean;
Begin
  IF maxTestNum <=0 then
  Begin
    PardonedRandom := false;
    EXIT;
  end;
  Lmt := High(drawers);
  IF (maxTestNum >= Lmt) then
  Begin
    PardonedRandom := true;
    EXIT;
  end;

  shuffle(drawers);
  PrisNum := 0;
  repeat
    //every prisoner uses his own list of drawers
    shuffle(PrisonersChoice);
    TestNum := 0;
    repeat
      Pardoned := drawers[PrisonersChoice[TestNum]] = PrisNum;
      inc(TestNum);
    until Pardoned OR (TestNum>=maxTestNum);
    IF Not(Pardoned) then
      BREAK;
    inc(PrisNum);
  until PrisNum>=Lmt;
  PardonedRandom:= Pardoned;
end;

function PardonedOptimized(maxTestNum: NativeUint):boolean;
var
  PrisNum,TestNum,NextNum,Cnt,Lmt : NativeUint;
  Pardoned : boolean;
Begin
  IF maxTestNum <=0 then
  Begin
    PardonedOptimized := false;
    EXIT;
  end;
  Lmt := High(drawers);
  IF (maxTestNum >= Lmt) then
  Begin
    PardonedOptimized := true;
    EXIT;
  end;

  shuffle(drawers);
  Lmt := High(drawers);
  IF maxTestNum >= Lmt then
  Begin
    PardonedOptimized := true;
    EXIT;
  end;
  PrisNum := 0;
  repeat
    Cnt := 0;
    NextNum := PrisNum;
    repeat
      TestNum := NextNum;
      NextNum := drawers[TestNum];
      inc(cnt);
      Pardoned := NextNum = PrisNum;
    until Pardoned OR (cnt >=maxTestNum);

    IF Not(Pardoned) then
      BREAK;
    inc(PrisNum);
  until PrisNum>Lmt;
  PardonedOptimized := Pardoned;
end;

procedure CheckRandom(testCount : NativeUint);
var
  i,cnt : NativeInt;
Begin
  cnt := 0;
  For i := 1 to rounds do
    IF PardonedRandom(TestCount) then
      inc(cnt);
  writeln('Randomly  ',cnt/rounds*100:7:2,'% get pardoned out of ',rounds,' checking max ',TestCount);
end;

procedure CheckOptimized(testCount : NativeUint);
var
  i,cnt : NativeInt;
Begin
  cnt := 0;
  For i := 1 to rounds do
    IF PardonedOptimized(TestCount) then
      inc(cnt);
  writeln('Optimized ',cnt/rounds*100:7:2,'% get pardoned out of ',rounds,' checking max ',TestCount);
end;

procedure OneCompareRun(PrisCnt:NativeInt);
var
  i,lmt :nativeInt;
begin
  setlength(drawers,PrisCnt);
  For i := 0 to PrisCnt-1 do
    drawers[i] := i;
  PrisonersChoice := copy(drawers);

  //test
  writeln('Checking ',PrisCnt,' prisoners');

  lmt := PrisCnt;
  repeat
    CheckOptimized(lmt);
    dec(lmt,PrisCnt DIV 10);
  until lmt < 0;
  writeln;

  lmt := PrisCnt;
  repeat
    CheckRandom(lmt);
    dec(lmt,PrisCnt DIV 10);
  until lmt < 0;
  writeln;
  writeln;
end;

Begin
  //init
  randomize;
  OneCompareRun(20);
  OneCompareRun(100);
end.
