program PermWithRep;//of different length
{$IFDEF FPC}
  {$mode Delphi}
  {$Optimization ON,All}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,classes {for stringlist};
const
  cTotalSum = 16;
  cMaxCardsOnDeck = cTotalSum;
  CMaxCardsUsed   = cTotalSum;

type
  tDeckIndex     = 0..cMaxCardsOnDeck-1;
  tSequenceIndex = 0..CMaxCardsUsed;
  tDiffCardCount = Byte;//A..Z

  tSetElem     = packed record
                   Elemcount : tDeckIndex;
                   Elem  : tDiffCardCount;
                 end;

  tRemSet = array [low(tDeckIndex)..High(tDeckIndex)] of tSetElem;
  tpRemSet = ^tRemSet;
  tRemainSet      = array [low(tSequenceIndex)..High(tSequenceIndex)] of tRemSet;
  tCardSequence   = array [low(tSequenceIndex)..High(tSequenceIndex)] of tDiffCardCount;

var
{$ALIGN 32}
  RemainSets     : tRemainSet;
  CardString    : AnsiString;
  CS : pchar;
  sl :TStringList;
  gblMaxCardsUsed,
  gblMaxUsedIdx,
  gblPermCount : NativeInt;

//*****************************************************************************
procedure Out_SL(const sl:TStringlIst;colCnt:NativeInt);
var
  j,i : NativeInt;
begin
  j := colCnt;
  For i := 0 to sl.count-1 do
  Begin
    write(sl[i],' ');
    dec(j);
    if j= 0 then
    Begin
      writeln;
      j := colCnt;
    end;
  end;
  if j <> colCnt then
    writeln;
end;

procedure SetClear(var ioSet:tRemSet);
begin
  fillChar(ioSet[0],SizeOf(ioSet),#0);
end;

procedure SetInit(var ioSet:tRemSet;const inSet:tRemSet);
var
  i,j,k,sum : integer;
begin
  ioSet := inSet;
  sum := 0;
  k := 0;
  write('Initial set : ');
  For i := Low(ioSet) to High(ioSet) do
  Begin
    j := inSet[i].ElemCount;
    if j <> 0 then
      inc(k);
    sum += j;
    For j := j downto 1 do
      write(chr(inSet[i].Elem));
  end;
  gblMaxCardsUsed := sum;
  gblMaxUsedIdx := k;
  writeln(' lenght: ',sum,' different elements : ',k);
end;

procedure EvaluatePerm;
Begin
  //append maximal 10000 strings
  if gblPermCount < 10000 then
    sl.append(CS);
end;

procedure Permute(depth,MaxCardsUsed:NativeInt);
var
  pSetElem : tpRemSet;//^tSetElem;
  i : NativeInt;
begin
  i := 0;
  pSetElem := @RemainSets[depth];
  repeat
    if pSetElem^[i].Elemcount > 0 then begin
      //take one of the same elements of the stack
      //insert in result here string
      CS[depth] := chr(pSetElem^[i].Elem);
      //done one permutation
      IF depth = MaxCardsUsed then
      begin
        inc(gblpermCount);
        EvaluatePerm;
      end
      else
      begin
        RemainSets[depth+1]:=RemainSets[depth];
        //remove one element
        dec(RemainSets[depth+1][i].ElemCount);
        Permute(depth+1,MaxCardsUsed);
      end;
    end;
    //move on to the next Elem
    inc(i);
  until i >= gblMaxUsedIdx;
end;

procedure Permutate(MaxCardsUsed:NativeInt);
Begin
  gblpermCount := 0;
  if MaxCardsUsed > gblMaxCardsUsed then
    MaxCardsUsed := gblMaxCardsUsed;

  if MaxCardsUsed>0 then
  Begin
    setlength(CardString,MaxCardsUsed);
    CS := @CardString[1];
    permute(0,MaxCardsUsed-1)
  end;
end;

var
  Manifolds : tRemSet;
  j :nativeInt;
Begin
  SetClear(Manifolds);
  with Manifolds[0] do
  begin
    Elemcount := 2; Elem := Ord('A');
  end;
  with Manifolds[1] do
  begin
    Elemcount := 3; Elem := Ord('B');
  end;
  with Manifolds[2] do
  begin
    Elemcount := 1; Elem := Ord('C');
  end;

  try
    sl := TStringList.create;

    SetInit(RemainSets[0], Manifolds);
    j := gblMaxCardsUsed;
    writeln('Count of elements: ',j);
    while j > 1 do
    begin
      sl.clear;
      Permutate(j);
      writeln('Length ',j:2,' Permutations ',gblpermCount:7);
      Out_SL(sl,80 DIV (Length(CS)+1));
      writeln;
      dec(j);
    end;
    //change to 1,2,3
    Manifolds[0].Elem := Ord('1');
    Manifolds[1].Elem := Ord('2');
    Manifolds[2].Elem := Ord('3');

    SetInit(RemainSets[0], Manifolds);
    j := gblMaxCardsUsed;
    writeln('Count of elements: ',j);
    while j > 1 do
    begin
      sl.clear;
      Permutate(j);
      writeln('Length ',j:2,' Permutations ',gblpermCount:7);
      Out_SL(sl,80 DIV (Length(CS)+1));
      writeln;
      dec(j);
    end;

  //extend by 3 more elements
  with Manifolds[3] do
  begin
    Elemcount := 2;   Elem := Ord('4');
  end;
  with Manifolds[4] do
  begin
    Elemcount := 3;  Elem := Ord('5');
  end;
  with Manifolds[5] do
  begin
    Elemcount := 1;  Elem := Ord('6');
  end;
  SetInit(RemainSets[0], Manifolds);
  j := gblMaxCardsUsed;
  writeln('Count of elements: ',j);
  sl.clear;
  Permutate(j);
  writeln('Length ',j:2,' Permutations ',gblpermCount:7);
  //Out_SL(sl,80 DIV (Length(CS)+1));
  writeln;

  except
    writeln(' Stringlist Error ');
  end;
  sl.free;
end.
