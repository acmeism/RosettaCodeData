program hammNumb;
{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON,ASMCSE,CSE,PEEPHOLE}
   {$ALIGN 16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  maxPrimFakCnt = 3;//3 or 3+8 if tNumber= double, else -1 for extended to keep data aligned
  minElemCnt = 10;
type
  tPrimList = array of NativeUint;
  tnumber = double;
  tpNumber= ^tnumber;
  tElem = record
             n   : tnumber;//ln(prime[0]^Pots[0]*...
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
  setlength(Pl,n);
  dec(n);
  For i := 0 to n do
    Pl[i] := cPl[i];
end;

procedure AusgabeElem(pElem: tElem);
var
  i : integer;
Begin
  with pElem do
  Begin
    IF n < 23 then
      write(round(exp(n)):16)
    else
      write('ln ',n:13:7);
    For i := 0 to maxPrimFakCnt do
      write(' ',PL[i]:2,'^',Pots[i]);
  end;
  writeln
end;

//LoE == List of Elements
function LoEGetNextNumber(pFR :tpFaktorRec):tElem;forward;

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
end;


procedure LoEFree(var FA:tArrFR);
var
  i : integer;
Begin
  For i := High(FA) downto Low(FA) do
    setlength(FA[i].frElems,0);
  setLength(FA,0);
end;

function LoEGetActElem(pFr:tpFaktorRec):tElem;
Begin
  with pFr^ do
    result := frElems[frAktIdx];
end;

function LoEGetActLstNumber(pFr:tpFaktorRec):tpNumber;
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
      frInsElems[cnt] := LoEGetNextNumber(frNextFr);
//   writeln( 'Ins ',frInsElems[cnt].n:10:8,' < ',pNum^:10:8);

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
// writeln(i:10,cnt:10,u:10); writeln( pElems^[i].n:10:8,' < ',frInsElems[cnt].n:10:8);
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
      pElems^[i] := LoEGetNextNumber(frNextFr);
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
  j : NativeUint;
begin
  with pFR^ do
  Begin
    //increase Elements by factor
    pElems := @frElems[0];
    for j := frMaxIdx Downto 0 do
      with pElems^[j] do
      Begin
        n := n+frLnPrime;
        inc(Pots[frPotNo]);
      end;
    //x^j -> x^(j+1)
    j := frActPot+1;
    with frActNumb do
    begin
      n:= j*frLnPrime;
      Pots[frPotNo]:= j;
    end;
    frActPot := j;
    //if something follows
    IF frNextFr <> NIL then
      LoEInsertNext(pFR,frActNumb.n);
    frAktIdx := 0;
  end;
end;

function LoEGetNextNumber(pFR :tpFaktorRec):tElem;
Begin
  with pFr^ do
  Begin
    result := frElems[frAktIdx];
    inc(frAktIdx);
    IF frMaxIdx < frAktIdx then
      LoENextList(pFr);
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

var
  T1,T0: tDateTime;
  FA: tArrFR;
  i : integer;
Begin
  PlInit(3);// 3 -> 2,3,5
  LoECreate(Pl,FA);
  i := 1;
  i := 1;
  T0 := time;

  For i := 1 to 20 do
    AusgabeElem(LoEGetNextNumber(@FA[0]));

  LoEGetNumber(@FA[0],1691);
  AusgabeElem(LoEGetNextNumber(@FA[0]));


  LoEGetNumber(@FA[0],1000*1000);
  AusgabeElem(LoEGetNextNumber(@FA[0]));
  LoEGetNumber(@FA[0],100*1000*1000);
  T1 := time;
  AusgabeElem(LoEGetNextNumber(@FA[0]));
  Writeln('Timed 100*1000*1000 in ',FormatDateTime('HH:NN:SS.ZZZ',T1-T0));


  Writeln('Actual Index ',ActIndex );
  AusgabeElem(LoEGetNextNumber(@FA[0]));
  For i := 0 to High(FA) do
    writeln(pL[i]:2,
     ' elemcount  ',FA[i].frMaxIdx+1:7,' out of',length(FA[i].frElems):7);
  LoEFree(FA);
End.
