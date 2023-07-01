program MianChowla;
//compiling with /usr/lib/fpc/3.2.0/ppcx64.2 -MDelphi -O4 -al "%f"
{$CODEALIGN proc=8,loop=4 }
uses
  sysutils;
const
  deltaK = 100;
  maxCnt = 1000;
type
  tElem  = Uint32;
  tpElem = pUint32;
  t_n = array[0..maxCnt+1] of tElem;
  t_n_sum_all = array[0..(maxCnt+1)*(maxCnt+2) DIV 2] of tElem;

var
  n_LastPos,
  n : t_n;

  n_sum_all : t_n_sum_all;

  maxIdx,
  maxN,
  max_SumIdx : NativeUInt;

procedure Init;
var
  i : NativeInt;
begin
  maxIdx := 1;
  maxN   := 1;
  n[maxIdx] := maxN;
  max_SumIdx := 1;
  n_sum_all[max_SumIdx] := 2*maxN;

  For i := 0 to maxCnt do
    n_LastPos[i] := 1;
end;

procedure InsertNew_sum(NewValue:NativeUint);
//insertion already knowning the positions
var
  pElem :tpElem;
  InsIdx,chkIdx,oldIdx,newIdx : nativeInt;
Begin
  newIdx := maxIdx;
  oldIdx := max_SumIdx;
  //append new value
  inc(maxIdx);
  n[maxIdx] := NewValue;
  //extend sum_
  inc(max_SumIdx,maxIdx);
  //heighest value already known
  InsIdx := max_SumIdx;
  n_sum_all[InsIdx] := 2*NewValue;
  //stop mark
  n_sum_all[InsIdx+1] := High(tElem);
  pElem := @n_sum_all[0];
  dec(InsIdx);
  //n_LastPos[newIdx]+newIdx-1 == InsIdx
  repeat
    //move old bigger values
    chkIdx := n_LastPos[newIdx]+newIdx-1;
    while InsIdx > chkIdx do
    Begin
      pElem[InsIdx] := pElem[oldIdx];
      dec(InsIdx);
      dec(oldIdx);
    end;
    //insert new value
    pElem[InsIdx] := NewValue+n[newIdx];
    dec(InsIdx);
    dec(newIdx);
    //all inserted
  until newIdx <= 0;
  //new minimum search position one behind, oldidx is one to small
  inc(oldidx,2);
  For newIdx := 1 to maxIdx do
    n_LastPos[newIdx] := oldIdx;
end;
procedure FindNew;
var
  pSumAll,pn : tpElem;
  i,LastCheckPos,newValue,newSum : NativeUint;
  TestRes : boolean;
begin
  //start value = last inserted value
  newValue := n[maxIdx];
  pSumAll := @n_sum_all[0];
  pn := @n[0];
  repeat
    //try next number
    inc(newValue);
    LastCheckPos := n_LastPos[1];
    i := 1;
    //check if sum = new is already n all_sum
    repeat
      newSum := newValue+pn[i];
      IF LastCheckPos < n_LastPos[i] then
        LastCheckPos := n_LastPos[i];
      while pSumAll[LastCheckPos] < newSum do
        inc(LastCheckPos);
      //memorize LastCheckPos;
      n_LastPos[i] := LastCheckPos;
      TestRes:= pSumAll[LastCheckPos] = newSum;
      IF TestRes then
        BREAK;
      inc(i);
    until i>maxIdx;
    //found?
    If not(TestRes) then
      BREAK;
  until false;
  InsertNew_sum(newValue);
end;

var
  T1,T0: Int64;
  i,k : NativeInt;

procedure Out_num(k:NativeInt);
Begin
  T1 := GetTickCount64;
  //     k      n[k]     average dist last deltak          total time
  writeln(k:6,n[k]:12,(n[k]-n[k-deltaK+1]) DIV deltaK:8,T1-T0:8,' ms');
end;

BEGIN
  writeln('Allocated memory ',2*SizeOf(t_n)+Sizeof(t_n_sum_all));
  T0 := GetTickCount64;
  while t0 = GetTickCount64 do;
  T0 := GetTickCount64;
  Init;

  k := deltaK;
  i := 1;
  repeat
    repeat
      FindNew;
      inc(i);
    until i=k;
    Out_num(k);
    k := k+deltaK;
  until k>maxCnt;
  writeln;
  writeln(#13,'The first 30 terms of the Mian-Chowla sequence are');
  For i := 1 to 30 do
    write(n[i],' ');
  writeln;
  writeln;
  writeln('The terms 91 - 100 of the Mian-Chowla sequence are');
  For i := 91 to 100 do
    write(n[i],' ');
  writeln;
END.
