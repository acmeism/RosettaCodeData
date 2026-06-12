program Perm5aus8;
//formerly roborally take 5 cards out of 8
{$IFDEF FPC}
  {$mode Delphi}
  {$Optimization ON,All}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,
  gmp;
const
  cTotalSum = 31;

  cMaxCardsOnDeck = cTotalSum;//8
  CMaxCardsUsed   = cTotalSum;//5

type
  tDeckIndex     = 0..cMaxCardsOnDeck-1;
  tSequenceIndex = 0..CMaxCardsUsed-1;

  tDiffCardCount = 0..9;

  tSetElem     = record
                      Elem  : tDiffCardCount;
                      Elemcount : tDeckIndex;
                 end;

  tSet          =  record
                      RemSet : array [low(tDiffCardCount)..High(tDiffCardCount)] of tSetElem;
                      MaxUsedIdx,
                      TotElemCnt   : byte;
                    end;

  tRemainSet      = array [low(tSequenceIndex)..High(tSequenceIndex)+1] of tSet;

  tCardSequence   = array [low(tSequenceIndex)..High(tSequenceIndex)] of tDiffCardCount;

var
  ManifoldOfDigit : array[tDiffCardCount] of Byte;
  TotalUsedDigits : array[tDeckIndex] of Byte;
  RemainSets     : tRemainSet;

  CardString    : AnsiString;

  PrimeCount : integer;
  PermCount  : integer;

//*****************************************************************************
var
  CS : pchar;
  z : mpz_t;

procedure SetInit(var ioSet:tSet);
var
  i : integer;
begin
  with ioSet do
    begin
    MaxUsedIdx := 0;
    For i := Low(tDiffCardCount) to High(tDiffCardCount) do
      with RemSet[i] do
        begin
        ElemCount := 0;
        Elem      := 0;
        end;
    end;
end;

procedure CheckPrime;inline;
begin
  mpz_set_str(z,CS,10);
  inc(PrimeCount,ORD(mpz_probab_prime_p(z,3)>0));
end;

procedure Permute(depth,MaxCardsUsed:NativeInt);
var
  pSetElem : ^tSetElem;
  i : NativeInt;
begin
  i := 0;
  pSetElem := @RemainSets[depth].RemSet[i];
  repeat
    if pSetElem^.Elemcount <> 0 then begin
      //take one of the same elements of the stack
      //insert in result here string
      CS[depth] := chr(pSetElem^.Elem+Ord('0'));
       //done one permutation
      IF depth = MaxCardsUsed then
      begin
        inc(permCount);
        CheckPrime;
      end
      else
      begin
        dec(pSetElem^.ElemCount);
        RemainSets[depth+1]:= RemainSets[depth];
        Permute(depth+1,MaxCardsUsed);
        //re-insert that element
        inc(pSetElem^.ElemCount);
      end;
    end;
    //move on to the next digit
    inc(pSetElem);
    inc(i);
  until i >=RemainSets[depth].MaxUsedIdx;
end;

procedure Check(n:nativeInt);
var
  i,dgtCnt,cnt,dgtIdx : NativeInt;
Begin
  SetInit(RemainSets[0]);
  dgtCnt := 0;
  dgtIdx := 0;
  //creating the start set.
  with RemainSets[0] do
  Begin
    For i in tDiffCardCount do
    Begin
      cnt := ManifoldOfDigit[i];
      if cnt > 0 then
      Begin
        with RemSet[dgtIdx] do
        Begin
          Elemcount := cnt;
          Elem  := i;
        end;
        inc(dgtCnt,cnt);
        inc(dgtIdx);
      end;
    end;
    TotElemCnt := dgtCnt;
    MaxUsedIdx := dgtIdx;

    CS := @CardString[1];
    //Check only useful end-digits
    For i := 0 to dgtIdx-1 do
    Begin
      if RemSet[i].Elem in[1,3,7,9]then
      Begin
        CS[dgtCnt-1] := chr(RemSet[i].Elem+Ord('0'));
        CS[dgtCnt] := #00;

        dec(RemSet[i].ElemCount);
        permute(0,dgtCnt-2);
        inc(RemSet[i].ElemCount);
      end;
    end;
  end;
end;

procedure AppendToSum(n,dgt,remsum:NativeInt);
var
  i: NativeInt;
begin
  inc(ManifoldOfDigit[dgt]);
  IF remsum > 0 then
    For i := dgt to 9 do
      AppendToSum(n+1,i,remsum-i)
  else
  Begin
    if remsum = 0 then
    Begin
      Check(n);
      //n is 0 based PrimeCount combinations of length n
      inc(TotalUsedDigits[n+1]);
    end;
  end;
  dec(ManifoldOfDigit[dgt]);
end;

procedure CheckAll(SumGoal:NativeInt);
var
  i :NativeInt;
begin
  setlength(CardString,SumGoal);
  IF sumGoal>cTotalSum then
    EXIT;
  fillchar(ManifoldOfDigit[0],SizeOf(ManifoldOfDigit),#0);
  permcount:=0;
  PrimeCount := 0;

  For i := 1 to 9 do
    AppendToSum(0,i,SumGoal-i);

  writeln('PrimeCount of generated numbers with digits sum of ',SumGoal,' are ',permcount);
  writeln('Propably primes ',PrimeCount);
  writeln;
end;
var
  T1,T0 : Int64;
  SumGoal: NativeInt;
BEGIN
  writeln('GMP-Version ',gmp.version);
  mpz_init_set_ui(z,0);
  T0 := GetTickCount64;
  For SumGoal := 25 to 25 do
  Begin
    CheckAll(SumGoal);
    T1 := GetTickCount64;Writeln((T1-T0)/1000:7:3,' s');
    T0 := T1;
  end;
  mpz_clear(z);
END.
