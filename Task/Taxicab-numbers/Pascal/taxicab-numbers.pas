program taxiCabNo;
uses
  sysutils;
type
  tPot3    = Uint32;
  tPot3Sol = record
               p3Sum : tPot3;
               i1,j1,
               i2,j2 : Word;
             end;
 tpPot3    = ^tPot3;
 tpPot3Sol = ^tPot3Sol;

var
//1290^3 = 2'146'689'000 < 2^31-1
//1190 is the magic number of the task ;-)
  pot3 : array[0..1190{1290}] of tPot3;//
  AllSol : array[0..3000] of tpot3Sol;
  AllSolHigh : NativeInt;

procedure SolOut(const s:tpot3Sol;no: NativeInt);
begin
  with s do
    writeln(no:5,p3Sum:12,' = ',j1:5,'^3 +',i1:5,'^3 =',j2:5,'^3 +',i2:5,'^3');
end;

procedure InsertAllSol;

var
  tmp: tpot3Sol;
  p :tpPot3Sol;
  p3Sum: tPot3;
  i: NativeInt;
Begin

  i := AllSolHigh;
  IF i > 0 then
  Begin
    p := @AllSol[i];
    tmp := p^;
    p3Sum := p^.p3Sum;
    //search the right place for insertion
    repeat
      dec(i);
      dec(p);
      IF (p^.p3Sum <= p3Sum) then
        BREAK;
    until  (i<=0);
    IF p^.p3Sum = p3Sum then
      EXIT;
    //free the right place by moving one place up
    inc(i);
    inc(p);
    IF i<AllSolHigh then
    Begin
      move(p^,AllSol[i+1],SizeOf(AllSol[0])*(AllSolHigh-i));
      p^ := tmp;
    end;
  end;
  inc(AllSolHigh);
end;

function searchSameSum(var sol:tpot3Sol):boolean;
//try to find a new combination for the same sum
//within the limits given by lo and hi
var
  Sum,
  SumLo: tPot3;
  hi,lo: NativeInt;
Begin
  with Sol do
  Begin
    Sum := p3Sum;
    lo:= i1;
    hi:= j1;
  end;

  repeat
    //Move hi down
    dec(hi);
    SumLo := Sum-Pot3[hi];
    //Move lo up an check until new combination found or implicite lo> hi
    repeat
      inc(lo)
    until (SumLo<=Pot3[lo]);
    //found?
    IF SumLo = Pot3[lo] then
      BREAK;
  until lo>=hi;

  IF lo<hi then
  Begin
    sol.i2:= lo;
    sol.j2:= hi;
    searchSameSum := true;
  end
  else
    searchSameSum := false;
end;

procedure Search;
var
  i,j: LongInt;
Begin
  AllSolHigh := 0;
  For j := 2 to High(pot3)-1 do
  Begin
    For i := 1 to j-1 do
    Begin
      with AllSol[AllSolHigh] do
      Begin
        p3Sum:= pot3[i]+pot3[j];
        i1:= i;
        j1:= j;
      end;
      IF searchSameSum(AllSol[AllSolHigh]) then
      BEGIN
        InsertAllSol;
        IF AllSolHigh>High(AllSol) then EXIT;
      end;
    end;
  end;
end;

var
  i: LongInt;
Begin
  For i := Low(pot3) to High(pot3) do
    pot3[i] := i*i*i;
  AllSolHigh := 0;
  Search;
  For i :=    0 to   24 do SolOut(AllSol[i],i+1);
  For i := 1999 to 2005 do SolOut(AllSol[i],i+1);
  writeln('count of solutions         ',AllSolHigh);
end.
