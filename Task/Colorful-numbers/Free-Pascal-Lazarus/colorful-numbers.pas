{$IFDEF FPC}
  {$mode Delphi}
  {$Optimization ON,All}
  {$Coperators ON}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  EightFak = 1*2*3*4*5*6*7*8;
type
  tDgt  = Int8;
  tpDgt = pInt8;
  tDgtfield = array[0..7] of tdgt;
  tpDgtfield = ^tDgtfield;

  tPermfield  =  tDgtfield;
  tAllPermDigits = array[0..EightFak] of tDgtfield;
  tMarkNotColorful = array[0..EightFak-1] of byte;

  tDat = Uint32;
  tusedMultiples = array[0..8*9 DIV 2-2] of tDat;

var
  AllPermDigits :tAllPermDigits;
  MarkNotColorful:tMarkNotColorful;
  permcnt,
  totalCntColorFul,CntColorFul : Int32;

procedure PermLex(n: Int32;StartVal:Int8);
var
  Perm : tPermField;
  k,j : Int32;
  temp: tDgt;
  pDat :tpDgt;
begin
  For j := 0 to n-1 do
    Perm[j]:= j+StartVal;

  permcnt := 0;
  dec(n);
  repeat
    AllPermDigits[permcnt] := Perm;
    inc(permcnt);
    k :=  N-1;
    pDat := @Perm[k];
    while (pDat[0]> pDat[1])  And (k >=Low(Perm) ) do
    begin
      dec(pDat);
      dec(k);
    end;

    if k >= Low(Perm)  then
    begin
      j := N;
      pDat := @Perm[j];
      temp := Perm[k];
      while (temp > pDat[0]) And (J >K) do
      begin
        dec(j);
        dec(pDat);
      end;

      Perm[k] := pDat[0];
      pDat[0] := temp;
      j := N;
      pDat := @Perm[j];
      Inc(k);

      while j>k do
      begin
        temp := pDat[0];
        pDat[0] := Perm[k];
        Perm[k] := temp;

        dec(j);
        dec(pDat);
        inc(k);
      end;
    end
    else
      break;
  until false;
end;

procedure OutNum(const num:tPermfield;dgtCnt: Int32);
var
  i : integer;
Begin
  For i := 0 to dgtcnt-1 do
    write(num[i]);
  writeln;
end;

function isAlreadyExisting(var uM :tusedMultiples; maxIdx : Int32;dat :tDat):boolean;
var
  I : Int32;
begin
  if maxIdx >= 0 then
  begin
    i := maxIdx;
    repeat
      if dat = uM[i] then
        EXIT(true);
      Dec(i);
    until i <0;
  end;
  uM[maxIdx+1]:= dat;
  result := false;
end;

function CalcValue(pDgtfield : tpDgtfield;TestDgtCnt:Int32):int32;
begin
  result :=  1;
  repeat
     result *=pDgtfield[TestDgtCnt];
     dec(TestDgtCnt);
   until TestDgtCnt <0;
end;

function isCheckColorful(dgtCnt: NativeInt;idx:Int32):boolean;
var
  usedMultiples : tusedMultiples;
  pDgtfield : ^tDgtfield;
  TestDgtCnt,StartIdx,value,maxIdx : Int32;
begin
  //needn't to test product of all digits.It's a singular max value
  dec(dgtCnt);
  pDgtfield := @AllPermDigits[idx];
  maxIdx := -1;

 //multiples of TestDgtCnt digits next to one another
  For TestDgtCnt := 0 to dgtCnt do
  begin
    For StartIdx := 0 to dgtCnt-TestDgtCnt do
    begin
      value := CalcValue(@pDgtfield[StartIdx],TestDgtCnt);
//      value := 1;      For l := 0 to TestDgtCnt do        value *=pDgtfield[StartIdx+l];
      if isAlreadyExisting(usedMultiples,maxIdx,value) then
        EXIT(false);
      inc(MaxIdx);
    end;
  end;
  inc(totalCntColorFul);
  inc(CntColorFul);
  result := true;
end;

procedure CheckDgtCnt(dgtCnt,delta:Int32);
var
  i,j : int32;
begin
  i := 0;
  CntColorFul := 0;
  if dgtCnt = 1 then
     CntColorFul := 2;//0,1

  if delta = 1 then
  begin
    For i := i to EightFak-1  do
      IF (MarkNotColorful[i]=0) AND not isCheckColorful(dgtCnt,i)then
        MarkNotColorful[i] := dgtcnt;
  end
  else
  Begin
    if dgtcnt<3 then
    //always colorful
    begin
      repeat
        isCheckColorful(dgtCnt,i);
        inc(i,delta);
      until i>EightFak-1;
    end
    else
    begin
      repeat
        IF (MarkNotColorful[i]=0) AND not isCheckColorful(dgtCnt,i) then
        begin
          //mark a range as not colorful
          j := i+delta-1;
          repeat
            MarkNotColorful[j] := dgtcnt;
            dec(j);
          until j < i;
        end;
        inc(i,delta);
      until i>EightFak-1;
    end;
  end;
end;

var
  T0 : Int64;
  i,j,delta: INteger;
Begin
  T0 := GetTickCount64;
  PermLex(8,2);
  //takes ~1 ms til here
  delta := 15;
  writeln('First colorful numbers less than 100');
  For i := 0 to 9 do
  Begin
    write(i:4);
    dec(delta);
  end;
  For i := 2 to 9 do
    For j := 2 to 9 do
      if j<> i then
      begin
        //write(i:3,j);
        dec(delta);
        if delta = 0 then
        begin
          delta:= 15;
          Writeln;
        end;
      end;
  writeln;
  writeln;
  Writeln('    digits     count of colorful numbers');
  totalCntColorFul := 2;//0,1,
  delta := EightFak-1;
  delta := (delta+1) DIV 8;
  j := 7;
  repeat
    CheckDgtCnt(8-j,delta);
    writeln(8-j:10,CntColorFul:10);
    if j = 0 then
      BREAK;
    delta := delta DIV j;
    dec(j);
  until false;
  Writeln;
  Writeln('Total number of colorful numbers: ',totalCntColorFul);
  Write('Highest Value :');
  For i := High(AllPermDigits) downto low(AllPermDigits) do
    if MarkNotColorful[i] = 0 then
    Begin
      OutNum(AllPermDigits[i],8);
      BREAK;
    end;

  Writeln('Runtime in ms ',GetTickCount64-T0);
end.
