program Esthetic;
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL} {$codealign proc=16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,//IntToStr
  strutils;//Numb2USA aka commatize
const
  ConvBase :array[0..15] of char= '0123456789ABCDEF';
  maxBase = 16;
type
  tErg = string[63];
  tCnt = array[0..maxBase-1] of UInt64;
  tDgtcnt = array[0..64] of tCnt;

//global
var
  Dgtcnt :tDgtcnt;

procedure CalcDgtCnt(base:NativeInt;var Dgtcnt :tDgtcnt);
var
  pCnt0,
  pCnt1 : ^tCnt;
  i,j,SumCarry: NativeUInt;
begin
  fillchar(Dgtcnt,SizeOf(Dgtcnt),#0);
  pCnt0 := @Dgtcnt[0];
  //building count for every first digit of digitcount:
  //example :count numbers starting "1" of lenght 13
  For i := 0 to Base-1 do
    pCnt0^[i] := 1;
  For j := 1 to High(Dgtcnt) do
  Begin
    pCnt1 := @Dgtcnt[j];
    //0 -> followed only by solutions of 1
    pCnt1^[0] := pCnt0^[1];
    //base-1 -> followed only by solutions of Base-2
    pCnt1^[base-1] := pCnt0^[base-2];
    //followed by solutions for i-1 and i+1
    For i := 1 to base-2 do
      pCnt1^[i]:= pCnt0^[i-1]+pCnt0^[i+1];
    //next row aka digitcnt
    pCnt0:= pCnt1;
  end;

  //converting to sum up each digit
  //example :count numbers starting "1" of lenght 13
  //-> count of all est. numbers from 1 to "1" with max lenght 13

  //delete leading "0"
  For j := 0 to High(Dgtcnt) do //High(Dgtcnt)
    Dgtcnt[j,0] := 0;

  SumCarry := Uint64(0);
  For j := 0 to High(Dgtcnt) do
  Begin
    pCnt0 := @Dgtcnt[j];
    For i := 0 to base-1 do
    begin
      SumCarry +=pCnt0^[i];
      pCnt0^[i] :=SumCarry;
    end;
  end;
end;

function ConvToBaseStr(n,base:NativeUint):tErg;
var
  idx,dgt,rst : Uint64;
Begin
  IF n = 0 then
  Begin
    result := ConvBase[0];
    EXIT;
  end;
  idx := High(result);
  repeat
    rst := n div base;
    dgt := n-rst*base;
    result[idx] := ConvBase[dgt];
    dec(idx);
    n := rst;
  until n=0;
  rst := High(result)-idx;
  move(result[idx+1],result[1],rst);
  setlength(result,rst);
end;

function isEsthetic(n,base:Uint64):boolean;
var
  lastdgt,
  dgt,
  rst : Uint64;
Begin
  result := true;
  IF n >= Base then
  Begin
    rst := n div base;
    Lastdgt := n-rst*base;
    n := rst;
    repeat
      rst := n div base;
      dgt := n-rst*base;
      IF sqr(lastDgt-dgt)<> 1 then
      Begin
        result := false;
        EXIT;
      end;
      lastDgt := dgt;
      n := rst;
    until n = 0;
  end;
end;

procedure Task1;
var
  i,base,cnt : NativeInt;
Begin
  cnt := 0;
  For base := 2 to 16 do
  Begin
    CalcDgtCnt(base,Dgtcnt);
    writeln(4*base,'th through ',6*base,'th esthetic numbers in base ',base);
    cnt := 0;
    i := 0;
    repeat
      inc(i);
      if isEsthetic(i,base) then
        inc(cnt);
    until cnt >= 4*base;

    repeat
      if isEsthetic(i,base) then
      Begin
        write(ConvToBaseStr(i,base),' ');
        inc(cnt);
      end;
      inc(i);
    until cnt > 6*base;
    writeln;
  end;
  writeln;
end;

procedure Task2;
var
  i : NativeInt;
begin
  write(' There are ',Dgtcnt[4][0]-Dgtcnt[3][0],' esthetic numbers');
  writeln(' between 1000 and 9999 ');
  For i := 1000 to 9999 do
  Begin
    if isEsthetic(i,10) then
      write(i:5);
  end;
  writeln;writeln;
end;

procedure Task3(Pot10: NativeInt);
//calculating esthetic numbers starting with "1" and Pot10+1 digits
var
  i : NativeInt;
begin
  write(' There are ',Numb2USA(IntToStr(Dgtcnt[Pot10][1]-Dgtcnt[Pot10][0])):26,' esthetic numbers');
  writeln(' between 1e',Pot10,' and 1.3e',Pot10);
  if Pot10 = 8 then
  Begin
    For i := 100*1000*1000 to 110*1000*1000-1 do
    Begin
      if isEsthetic(i,10) then
        write(i:10);
    end;
    writeln;
    //Jump over "11"
    For i := 120*1000*1000 to 130*1000*1000-1 do
    Begin
      if isEsthetic(i,10) then
        write(i:10);
    end;
    writeln;writeln;
  end;
end;

var
  i:NativeInt;
BEGIN
  Task1;
  //now only base 10 is used
  CalcDgtCnt(10,Dgtcnt);
  Task2;
  For i := 2 to 20 do
    Task3(3*i+2);
  writeln;
  write(' There are ',Numb2USA(IntToStr(Dgtcnt[64][0])),' esthetic numbers');
  writeln(' with max 65 digits ');
  writeln;
  writeln(' The count of numbers with 64 digits like https://oeis.org/A090994');
  writeln(Numb2USA(IntToStr(Dgtcnt[64][0]-Dgtcnt[63][0])):28);
end.
