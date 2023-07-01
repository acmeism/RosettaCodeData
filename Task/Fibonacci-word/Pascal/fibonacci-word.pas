program FibWord;
{$IFDEF DELPHI}
   {$APPTYPE CONSOLE}
{$ENDIF}
const
  FibSMaxLen = 35;
type
  tFibString = string[2*FibSMaxLen];//Ansistring;
  tFibCnt = longWord;
  tFib = record
            ZeroCnt,
            OneCnt : tFibCnt;
//            fibS   : tFibString;//didn't work :-(
         end;
var
  FibSCheck : boolean;
  Fib0,Fib1 : tFib;
  FibS0,FibS1: tFibString;

procedure  FibInit;
Begin
  with Fib0 do
  begin
    ZeroCnt := 1;
    OneCnt  := 0;
  end;

  with Fib1 do
  begin
    ZeroCnt := 0;
    OneCnt  := 1;
  end;
  FibS0 := '1';
  FibS1 := '0';
  FibSCheck := true;
end;

Function FibLength(const F:Tfib):tFibCnt;
begin
  FibLength := F.ZeroCnt+F.OneCnt;
end;

function FibEntropy(const F:Tfib):extended;
const
  rcpLn2 = 1.0/ln(2);
var
  entrp,
  ratio: extended;
begin
  entrp := 0.0;
  ratio := F.ZeroCnt/FibLength(F);
  if Ratio <> 0.0 then
    entrp :=  -ratio*ln(ratio)*rcpLn2;
  ratio := F.OneCnt/FibLength(F);
  if Ratio <> 0.0 then
    entrp :=  entrp-ratio*ln(ratio)*rcpLn2;
  FibEntropy:=entrp
end;

procedure FibSExtend;
var
  tmpS : tFibString;
begin
  IF FibSCheck then
  begin
    tmpS  := FibS0+FibS1;
    FibS0 := FibS1;
    FibS1 := tmpS;
    FibSCheck := (length(FibS1) < FibSMaxLen);
  end;
end;

procedure FibNext;
var
  tmpFib : tFib;
Begin
  tmpFib.ZeroCnt := Fib0.ZeroCnt+Fib1.ZeroCnt;
  tmpFib.OneCnt  := Fib0.OneCnt +Fib1.OneCnt;
  Fib0 := Fib1;
  Fib1 := tmpFib;
  IF FibSCheck then
    FibSExtend;
end;

procedure FibWrite(const F:Tfib);
begin
//  With F do
//    write(ZeroCnt:10,OneCnt:10,FibLength(F):10,FibEntropy(f):17:14);
  write(FibLength(F):10,FibEntropy(F):17:14);
  IF FibSCheck then
    writeln('  ',FibS1)
  else
    writeln('  ....');
end;

var
  i : integer;
BEGIN
  FibInit;
  writeln('No.     Length   Entropy         Word');
  write(1:4);FibWrite(Fib0);
  write(2:4);FibWrite(Fib1);
  For i := 3 to 37 do
  begin
    FibNext;
    write(i:4);
    FibWrite(Fib1);
  end;
END.
