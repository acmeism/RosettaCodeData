{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON,ALL}
   {$CODEALIGN proc=32,loop=1}
   {$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  //PlInit(4); <= maxPrimFakCnt+1
  maxPrimFakCnt = 3;//3,7,11 to keep data 8-Byte aligned
  minElemCnt = 10;
type
  tPrimList = array of NativeUint;
  tnumber = extended;
  tpNumber= ^tnumber;
  tElem = record
             n   : tnumber;//ln(prime[0]^Pots[0]*...
             dummy: array[0..5] of byte;//extend extended to 16 byte
             Pots: array[0..maxPrimFakCnt] of word;
           end;
  tpElem  = ^tElem;
  tElems  = array of tElem;
  tElemArr  = array [0..0] of tElem;
  tpElemArr  = ^tElemArr;

  tpFaktorRec = ^tFaktorRec;
  tFaktorRec = record
                 frElems  : tElems;
                 frInsElems: tElems;
                 frAktIdx : NativeUint;
                 frMaxIdx : NativeUint;
                 frPotNo  : NativeUint;
                 frActPot : NativeUint;
                 frNextFr : tpFaktorRec;
                 frActNumb: tElem;
                 frLnPrime: tnumber;
               end;
  tArrFR = array of tFaktorRec;

  //LoE == List of Elements
  function LoEGetNextElement(pFR :tpFaktorRec):tElem;forward;

var
  Pl : tPrimList;
  ActIndex  : NativeUint;
  ArrInsert : tElems;

procedure PlInit(n: integer);
const
 cPl : array[0..11] of byte=(2,3,5,7,11,13,17,19,23,29,31,37);
var
  i : integer;
Begin
  IF n>High(cPl)+1 then
    n := High(cPl)
  else
    IF n < 0 then
      n := 1;
  IF maxPrimFakCnt+1 < n then
  Begin
    writeln(' Need to compile with bigger maxPrimFakCnt ');
    Halt(0);
  end;
  setlength(Pl,n);
  dec(n);
  For i := 0 to n do
    Pl[i] := cPl[i];
end;

procedure AusgabeElem(pElem: tElem;ShowPot:Boolean=false);
var
  i : integer;
Begin
  with pElem do
  Begin
    IF n < 23 then
      write(round(exp(n)),' ')
    else
      write('ln ',n:13:7);
    IF ShowPot then
    Begin
      For i := 0 to maxPrimFakCnt do
        write(' ',PL[i]:2,'^',Pots[i]);
      writeln
    end;
  end;
end;

procedure LoECreate(const Pl: tPrimList;var FA:tArrFR);
var
  i : integer;
Begin
  setlength(ArrInsert,100);
  setlength(FA,Length(PL));
  For i := 0 to High(PL) do
    with FA[i] do
    Begin
      //automatic zeroing
      IF i < High(PL) then
      Begin
        setlength(frElems,minElemCnt);
        setlength(frInsElems,minElemCnt);
        frNextFr := @FA[i+1]
      end
      else
      Begin
        setlength(frElems,2);
        setlength(frInsElems,0);
        frNextFr := NIL;
      end;
      frPotNo  := i;
      frLnPrime:= ln(PL[i]);
      frMaxIdx := 0;
      frAktIdx := 0;
      frActPot := 1;
      With frElems[0] do
      Begin
        n := frLnPrime;
        Pots[i]:= 1;
      end;
      frActNumb := frElems[0];
  end;
  ActIndex := 0;
end;


procedure LoEFree(var FA:tArrFR);
var
  i : integer;
Begin
  For i := High(FA) downto Low(FA) do
    setlength(FA[i].frElems,0);
  setLength(FA,0);
end;

function LoEGetActElem(pFr:tpFaktorRec):tElem;inline;
Begin
  with pFr^ do
    result := frElems[frAktIdx];
end;

function LoEGetActLstNumber(pFr:tpFaktorRec):tpNumber;inline;
Begin
  with pFr^ do
    result := @frElems[frAktIdx].n;
end;

procedure LoEIncInsArr(var a:tElems);
Begin
  setlength(a,Length(a)*8 div 5);
end;

procedure LoEIncreaseElems(pFr:tpFaktorRec;minCnt:NativeUint);
var
  newLen: NativeUint;
Begin
  with pFR^ do
  begin
    newLen := Length(frElems);
    minCnt := minCnt+frMaxIdx;
    repeat
      newLen := newLen*8 div 5 +1;
    until newLen > minCnt;
    setlength(frElems,newLen);
  end;
end;

procedure LoEInsertNext(pFr:tpFaktorRec;Limit:tnumber);
var
  pNum : tpNumber;
  pElems : tpElemArr;
  cnt,i,u : NativeInt;
begin
  with pFr^ do
  Begin
    //collect numbers of heigher primes
    cnt := 0;
    pNum := LoEGetActLstNumber(frNextFr);
    while Limit > pNum^ do
    Begin
      frInsElems[cnt] := LoEGetNextElement(frNextFr);
      inc(cnt);
      IF cnt > High(frInsElems) then
        LoEIncInsArr(frInsElems);
      pNum := LoEGetActLstNumber(frNextFr);
    end;

    if cnt = 0 then
     EXIT;

    i := frMaxIdx;
    u := frMaxIdx+cnt+1;

    IF u > High(frElems) then
      LoEIncreaseElems(pFr,cnt);

    IF frPotNo =  0 then
      inc(ActIndex,u);
    //Merge
    pElems := @frElems[0];
    dec(cnt);
    dec(u);
    frMaxIdx:= u;
    repeat
      IF pElems^[i].n < frInsElems[cnt].n then
      Begin
        pElems^[u] := frInsElems[cnt];
        dec(cnt);
      end
      else
      Begin
        pElems^[u] := pElems^[i];
        dec(i);
      end;
      dec(u);
    until (i<0) or (cnt<0);
    IF i < 0 then
      For u := cnt downto 0 do
        pElems^[u] := frInsElems[u];
  end;
end;

procedure LoEAppendNext(pFr:tpFaktorRec;Limit:tnumber);
var
  pNum : tpNumber;
  pElems : tpElemArr;
  i : NativeInt;
begin
  with pFr^ do
  Begin
    i := frMaxIdx+1;
    pElems := @frElems[0];
    pNum := LoEGetActLstNumber(frNextFr);
    while Limit > pNum^ do
    Begin
      IF i > High(frElems) then
      Begin
        LoEIncreaseElems(pFr,10);
        pElems := @frElems[0];
      end;
      pElems^[i] := LoEGetNextElement(frNextFr);
      inc(i);
      pNum := LoEGetActLstNumber(frNextFr);
    end;
    inc(ActIndex,i);
    frMaxIdx:= i-1;
  end;
end;

procedure LoENextList(pFr:tpFaktorRec);
var
  pElems : tpElemArr;
  j,PotNum : NativeInt;
  lnPrime : tnumber;
begin
  with pFR^ do
  Begin
    //increase all Elements by factor
    pElems := @frElems[0];
    LnPrime := frLnPrime;
    PotNum := frPotNo;
    for j := frMaxIdx Downto 0 do
      with pElems^[j] do
      Begin
        n := LnPrime+n;
        inc(Pots[PotNum]);
      end;
    //x^j -> x^(j+1)
    j := frActPot+1;
    with frActNumb do
    begin
      n:= j*LnPrime;
      Pots[PotNum]:= j;
    end;
    frActPot := j;
    //if something follows
    IF frNextFr <> NIL then
      LoEInsertNext(pFR,frActNumb.n);
    frAktIdx := 0;
  end;
end;

function LoEGetNextElementPointer(pFR :tpFaktorRec):tpElem;
Begin
  with pFr^ do
  Begin
    IF frMaxIdx < frAktIdx then
      LoENextList(pFr);
    result := @frElems[frAktIdx];
    inc(frAktIdx);
    inc(ActIndex);
  end;
end;

function LoEGetNextElement(pFR :tpFaktorRec):tElem;
Begin
  with pFr^ do
  Begin
    result := frElems[frAktIdx];
    inc(frAktIdx);
    IF frMaxIdx < frAktIdx then
      LoENextList(pFr);
    inc(ActIndex);
  end;
end;

function LoEGetNextNumber(pFR :tpFaktorRec):tNumber;
Begin
  with pFr^ do
  Begin
    result := frElems[frAktIdx].n;
    inc(frAktIdx);
    IF frMaxIdx < frAktIdx then
      LoENextList(pFr);
    inc(ActIndex);
  end;
end;

procedure LoEGetNumber(pFR :tpFaktorRec;no:NativeUint);
Begin
  dec(no);
  while ActIndex < no do
    LoENextList(pFR);
  with pFr^ do
    frAktIdx := (no-(ActIndex-frMaxIdx)-1);
end;

procedure first50;
var
  FA: tArrFR;
  i : integer;
Begin
  LoECreate(Pl,FA);
  write(1,' ');
  For i := 1 to 49 do
    AusgabeElem(LoEGetNextElement(@FA[0]));
  writeln;
  LoEFree(FA);
end;

procedure GetDigitCounts(MaxDigit:Uint32);
var
  T1,T0 : TDateTime;
  FA: tArrFR;
  i,j,LastCnt : NativeUint;
Begin
  T0 := now;
  inc(MaxDigit);
  LoECreate(Pl,FA);
  i := 1;
  j := 0;
  writeln('Digits   count    total count ');
  repeat
    LastCnt := j;
    repeat
      inc(j);
      with LoEGetNextElementPointer(@FA[0])^ do
        IF (Pots[2]= i) AND (Pots[0]= i) then
          break;
    until false;
    writeln(i:4,j-LastCnt:12,j:15,(now-T0)*86.6e3:10:3,' s');
    LastCnt := j;
    inc(i);
  until i = MaxDigit;
  LoEFree(FA);
  T1 := now;
  writeln('Total number of humble numbers found: ',j);
  writeln('Running time: ',(T1-T0)*86.6e6:0:0,' ms');
end;

Begin
  //check if PlInit(4); <= maxPrimFakCnt+1
  PlInit(4);// 3 -> 2,3,5/ 4  -> 2,3,5,7
  first50;
  GetDigitCounts(100);
End.
