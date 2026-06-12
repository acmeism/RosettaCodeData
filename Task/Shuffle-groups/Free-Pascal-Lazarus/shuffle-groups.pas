program ShuffleGroups;
{$MODE DELPHI}{$optimization ON,ALL}

uses
  sysutils;
const
  BASE = 10;
  MaxLmt = 1402857;//1037520684;//
type
  tDgts  = 0..BASE-1;
  tUsedDigits = set of tDgts;
  tcntOfDigit = array[tDgts] of Byte;
  tdigitsOfNum = packed record
                   digit : array[0..21] of byte;
                   cntOfDigit: tcntOfDigit;
                   Num : Uint32;
                   witness : tUsedDigits;
                   cntDigits,
                   witcnt: byte;
                 end;

  tpdigitsOfNum = ^tdigitsOfNum;
  tWitness =  packed record
                Num : Uint32;
                witness : tUsedDigits;
                witcnt,dummy : byte;
              end;

  tWitCntOcc = array[tDgts] of Uint32;
  tSolutions = array of tWitness;
var
  GBLIncCount : NativeUint;

function Numb2USA(n:Uint64):Ansistring;
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
  j := i+ (i-1) div 3;
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];pI[j-1] := pI[i-1];pI[j-2] := pI[i-2];
       //insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;
procedure CheckWitCountOccurence(var WCO : tWitCntOcc;const Sol:tSolutions; til:Int32);
var
  cnt: Int32;
begin
  writeln('For the first ',til+1,' shuffle groups, there are:');
  FillChar(WCO,SizeOf(WCO),#0);
  while til>=0 do
  begin
    inc(WCO[Sol[til].witcnt]);
    dec(til);
  end;

  writeln(' FacCnt  found witnesses');
  For til := 1 to Base-1 do
  begin
    cnt := WCO[til];
    if cnt<> 0 then
      writeln(Numb2USA(til):7,Numb2USA(cnt):9);
  end;
  Writeln;
end;

procedure OutWitness(const n:tWitness);
var
  i: NativeINt;
begin
  with n do
  begin
    write(Numb2USA(witCnt):7,Numb2USA(Num):14,'  ');
    For i := 2 to BASE-1 do
      if i in witness then
        write(' |x',i:1,Numb2USA(i*num):14);
  end;
  writeln;
end;

procedure WriteHead;
begin
  Writeln('    idx    cnt           num   fac');
end;

procedure FirstN_Sol(const Sol:tSolutions;cnt:NativeInt);
var
  i : NativeInt;
begin
  if cnt > high(Sol) then
    cnt := High(Sol);
  writeln;
  Writeln('First ',cnt,' shuffle groups:');
  WriteHead;
  For i := 0 to cnt do
  Begin
    write(Numb2USA(i+1):7);
    OutWitness(Sol[i]);
  end;
  writeln;
end;

procedure FirstN_Solgr4(const Sol:tSolutions);
var
  i : NativeInt;
begin
  Writeln('First with more than 4 witnesses:');
  WriteHead;
  i := 0;
  repeat
    if Sol[i].witCnt>4 then
      BREAK;
    inc(i);
  until i > High(Sol);
  if i <= High(Sol)then
  begin
    write(Numb2USA(i+1):7);
    OutWitness(Sol[i])
  end
  else
    writeln('Not found til ',i);
  writeln;
end;

function FirstSolWithExact(const Sol:tSolutions;cnt,til:UInt32):Uint32;
Begin
  Writeln('First shuffle group with exactly ',cnt,' witnesses');
  WriteHead;
  result := 0;
  repeat
    if Sol[result].witCnt=cnt then
      BREAK;
    inc(result);
  until result > til;
  if result <= til then
  begin
    write(Numb2USA(result+1):7);
    OutWitness(Sol[result]);
  end
  else
  begin
    writeln('Not found til ',result);
    result := 0;
  end;
  writeln;
end;
(*
function TestSameDigits(const A,B:tpdigitsOfNum):boolean;inline;
var
  dgt : NativeInt;
Begin
  For dgt := low(tDgts) to high(tDgts)  do
    if A.cntOfDigit[dgt] <> B.cntOfDigit[dgt] then
      EXIT(false);
  EXIT(true);
end;
*)
function TestSameDigits(const A,B:tpdigitsOfNum):boolean;inline;
//cntOfDigit = array[0..9] of byte;
Begin
  //check first 8 Bytes at once
  if pUint64(@A.cntOfDigit[0])^ <> pUint64(@B.cntOfDigit[0])^ then
    EXIT(false);
  //check following 2 Bytes at once
  if pUint16(@A.cntOfDigit[8])^ <> pUint16(@B.cntOfDigit[8])^ then
    EXIT(false);
  EXIT(true);
end;

procedure GetDigits(n : NativeUint;res:tpdigitsOfNum);
var
  q,dgt,cnt: NativeUint;
begin
  fillchar(res^,SizeOf(res^),#0);
  with res^ do
  begin
    num := n;
    q := n DIV BASE;
    dgt := n-BASE*q;
    inc(cntOfDigit[dgt]);
    digit[0] := dgt;
    n := q;
    cnt := 1;
    repeat
      q := n DIV BASE;
      dgt := n-BASE*q;
      digit[cnt] := dgt;
      inc(cntOfDigit[dgt]);
      n := q;
      inc(cnt);
    until n= 0;
    cntDigits := cnt;
  end;
end;

function NextDgtcnt(pT:tpdigitsOfNum):NativeInt;
var
  i,fac : NativeUint;
begin
 //5001 ->10001
  i := pT^.num*2-1;
  For Fac := 1 to Base-1 do
  begin
    GetDigits(Fac*i,pT);
    inc(pT);
  end;
  result := BASE-1;
end;

procedure IncDigits(res:tpdigitsOfNum;carry:NativeInt = 1);inline;
//carry must be in the range of 0..BASE-1
var
  dgt,idx: NativeInt;
Begin
  with res^ do
  begin
    num += carry;
    idx := 0;
    repeat
      dgt :=  digit[idx];
      dec(cntOfDigit[dgt]); //correct cntOfDigit
      dgt += carry;
      //IF dgt>= BASE then Begin carry:=1; dgt -= BASE;end;
      //version without IF
      carry := ORD(dgt>=Base);// [0,1]
      dgt -= BASE AND (-carry);// [0,BASE] // BASE AND -1 = BASE

      digit[idx] := dgt;
      inc(cntOfDigit[dgt]);
      inc(idx);
    until (carry=0) OR (idx >= cntDigits);

    If carry <> 0 then
    begin
      digit[idx] := carry;
      inc(cntOfDigit[carry]);
      inc(cntDigits);
    end;
    Inc(GblIncCount);

    witness := [];
    witcnt := 0;
  end;
end;

var
  Solutions : tSolutions;
  Test  : array[1..Base-1] of tdigitsOfNum;
  pTest1,pTestFac :tpdigitsOfNum;
  WitnessCntOccurences : tWitCntOcc;
  fac,TotalCount,maxFac : NativeInt;
BEGIN
  //falling from sky
  setlength(Solutions,126853);

  TotalCount := 0;
  //Init all manifold numbers to zero.
  //Test[1] is the number. Test[n] = n*Test[1]

  pTest1 := @Test[1];
  GetDigits(0,pTest1);
  For Fac := 2 to BASE-1 do
    Test[Fac] :=Test[1];
  maxFac := BASE-1;
  repeat
    //increment all numbers in use
    pTestFac :=pTest1;
    For Fac := 1 to maxFac do
    Begin
      IncDigits(pTestFac,Fac);
      inc(pTestFac);
    end;

    if pTest1^.digit[0] = 0 then
      continue;

    with pTest1^ do
      if digit[cntDigits-1] = BASE DIV 2 then
       maxFac := NextDgtcnt(pTest1);
    //check if multilples of number share the same digits
    pTestFac := pTest1;
    For Fac := 2 to maxFac do
    begin
      inc(pTestFac);
      if pTest1.cntDigits <> pTestFac^.cntDigits then
        dec(maxFac);
      IF TestSameDigits(pTest1,pTestFac) then
        with ptest1^ do
        begin
          include(witness,fac);
          inc(witCnt);
        end;
    end;

    if ptest1^.witCnt <> 0 then
    Begin
      with Solutions[TotalCOunt] do
      begin
        num := pTest1^.num;
        witness := pTest1^.witness;
        witCnt := pTest1^.witCnt;
      end;
      inc(TotalCount);
    end;
  until  (TotalCount>Length(Solutions)) OR (ptest1^.witCnt = 4);

  writeln('Use of IncDigts ',Numb2USA(GBLIncCount):16);
  writeln('Found solutions ', Numb2USA(TotalCount):16);

  FirstN_Sol(Solutions,20);
  FirstN_Solgr4(Solutions);
  fac := FirstSolWithExact(Solutions,3,TotalCount);
  CheckWitCountOccurence(WitnessCntOccurences,Solutions,fac);
  fac := FirstSolWithExact(Solutions,4,TotalCount);
  CheckWitCountOccurence(WitnessCntOccurences,Solutions,fac);
END.
