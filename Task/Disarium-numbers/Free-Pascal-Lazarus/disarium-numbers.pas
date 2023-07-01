program disarium;
//compile with fpc -O3 -Xs
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$IFDEF FPC}
  {$Mode Delphi}
  uses
    sysutils;
{$ELSE}
  uses
    system.SysUtils;
{$ENDIF}
const
 MAX_BASE = 16;
 cDigits : array[0..MAX_BASE-1] of char =
    ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

 MAX_DIGIT_CNT = 31;

type
  tDgt_cnt= 0..MAX_DIGIT_CNT-1;
  tdgtPows = array[tDgt_cnt,0..MAX_BASE] of Uint64;
  tdgtMaxSumPot = array[tDgt_cnt] of Uint64;
  tmyDigits = record
                dgtPot  : array[tDgt_cnt] of Uint64;
                dgtSumPot : array[tDgt_cnt] of Uint64;
                dgtNumber : UInt64;
                digit  : array[0..31] of byte;
                dgtMaxLen : tDgt_cnt;
              end;

const
  UPPER_LIMIT = 100*1000*1002;

var
{$Align 32}
  dgtPows :tdgtPows;

procedure InitMyPots(var mp :tdgtPows;base:int32);
var
  pot,dgt:Uint32;
  p : Uint64;
begin
  fillchar(mp,SizeOf(mp),#0);
  For dgt := 0 to BASE do
  begin
    p := dgt;
    For pot in tDgt_cnt do
    begin
      mp[pot,dgt] := p;
      p := p*dgt;
    end;
  end;
  p := 0;
end;

procedure Out_Digits(var md:tmyDigits);
var
  i : Int32;
Begin
  with md do
  begin
   write('dgtNumber ',dgtNumber,' = ',dgtSumPot[0],' in Base ');
   For i := dgtMaxLen-1 downto 0 do
     write(cDigits[digit[i]]);
   writeln;
  end;
end;

procedure IncByOne(var md:tmyDigits;Base: Int32);inline;
var
  PotSum : Uint64;
  potBase: nativeInt;
  dg,pot,idx : Int32;

Begin
  with md do
  begin
    //first digit seperate
    pot := dgtMaxLen-1;
    dg := digit[0]+1;
    if dg < BASE then
    begin
      inc(dgtNumber);
      digit[0]:= dg;
      dgtPot[0] := dgtPows[pot,dg];
      dgtSumPot[0] := dgtSumPot[1] + dgtPot[0];
      EXIT;
    end;

    dec(dgtNumber,Base-1);
    digit[0]:= 0;
    dgtPot[0]:= 0;
    dgtSumPot[0] := dgtSumPot[1];

    potbase := Base;
    idx := 1;
    dec(pot);
    while pot >= 0 do
    Begin
      dg := digit[idx]+1;
      if dg < BASE then
      begin
        inc(dgtNumber,potbase);
        digit[idx]:= dg;
        dgtPot[idx]:= dgtPows[pot,dg];
        PotSum := dgtSumPot[idx+1];
        //update sum
        while idx>=0 do
        begin
          inc(PotSum,dgtPot[idx]);
          dgtSumPot[idx] := PotSum;
          dec(idx);
        end;
        EXIT;
      end;
      dec(dgtNumber,(dg-1)*PotBase);
      potbase *= Base;
      digit[idx]:= 0;
      dgtPot[idx] := 0;
      dec(pot);
      inc(idx);
    end;

    For pot := idx downto 0 do
    Begin
      dgtPot[idx] :=0;
      dgtSumPot[pot] := 1;
    end;
    digit[idx] := 1;
    dgtPot[idx] :=1;
    dgtMaxLen := idx+1;
    dgtNumber := potbase;
  end;
end;

procedure OneRun(var s: tmyDigits;base:UInt32;Limit:Int64);
var
  i : int64;
  cnt : Int32;
begin
  Writeln('Base = ',base);
  InitMyPots(dgtPows,base);
  fillchar(s,SizeOf(s),#0);
  s.dgtMaxLen := 1;

  i := 0;
  cnt := 0;
  repeat
    if s.dgtSumPot[0] = s.dgtNumber then
    Begin
      Out_Digits(s);
      inc(cnt);
    end;
    IncByOne(s,base);
    inc(i);
  until (i>=Limit);
  writeln ( i,' increments and found ',cnt);
end;

var
{$Align 32}
  s  : tmyDigits;
  T0: TDateTime;
  base: nativeInt;
Begin
  base := 10;
  T0 := time;
  OneRun(s,base,2646799);
  T0 := (time-T0)*86400;
  writeln(T0:8:3,' s');
  writeln;

  base := 11;
  T0 := time;
  OneRun(s,base,100173172);
  T0 := (time-T0)*86400;
  writeln(T0:8:3,' s');
  writeln;
  {$IFDEF WINDOWS}
   readln;
  {$ENDIF}
end.
