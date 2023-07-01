program VanEck;
{
* A:  The first term is zero.
    Repeatedly apply:
        If the last term is *new* to the sequence so far then:
B:          The next term is zero.
        Otherwise:
C:          The next term is how far back this last term occured previousely.}
uses
  sysutils;
const
  MAXNUM = 32381775;//1000*1000*1000;
  MAXSEENIDX = (1 shl 7)-1;
var
  PosBefore : array of UInt32;
  LastSeen  : array[0..MAXSEENIDX]of UInt32;// circular buffer
  SeenIdx,HaveSeen : Uint32;

procedure OutSeen(Cnt:NativeInt);
var
  I,S_Idx : NativeInt;
Begin
  IF Cnt > MAXSEENIDX then
    Cnt := MAXSEENIDX;
  If  Cnt > HaveSeen  then
    Cnt := HaveSeen;
  S_Idx := SeenIdx;
  S_Idx := (S_Idx-Cnt);
  IF S_Idx < 0 then
    inc(S_Idx,MAXSEENIDX);
  For i := 1 to Cnt do
  Begin
    write(' ',LastSeen[S_Idx]);
    S_Idx:= (S_Idx+1) AND MAXSEENIDX;
  end;
  writeln;
end;

procedure Test(MaxTestCnt: Uint32);
var
  i, actnum, Posi, S_Idx: Uint32;
  {$IFDEF FPC}
  pPosBef, pSeen: pUint32;
  {$ELSE}
  pPosBef, pSeen: array of UInt32;
  {$ENDIF}
begin
  HaveSeen := 0;
  if MaxTestCnt > MAXNUM then
    EXIT;

  Fillchar(LastSeen, SizeOf(LastSeen), #0);
  //setlength and clear
  setlength(PosBefore, 0);
  setlength(PosBefore, MaxTestCnt);

 {$IFDEF FPC}
  pPosBef := @PosBefore[0];
  pSeen := @LastSeen[0];
 {$ELSE}
  SetLength(pSeen, SizeOf(LastSeen));
  setlength(pPosBef, MaxTestCnt);
  move(PosBefore[0], pPosBef[0], length(pPosBef));
  move(LastSeen[0], pSeen[0], length(pSeen));
 {$ENDIF}

  S_Idx := 0;
  i := 1;
  actnum := 0;
  repeat
    // save value
    pSeen[S_Idx] := actnum;
    S_Idx := (S_Idx + 1) and MAXSEENIDX;
    //examine new value often out of cache
    Posi := pPosBef[actnum];
    pPosBef[actnum] := i;
//  if Posi=0 ? actnum = 0:actnum = i-Posi
    if Posi = 0 then
      actnum := 0
    else
      actnum := i - Posi;
    inc(i);
  until i > MaxTestCnt;
  HaveSeen := i - 1;
  SeenIdx := S_Idx;

  {$IFNDEF FPC}

  move(pPosBef[0], PosBefore[0], length(pPosBef));
  move(pSeen[0], LastSeen[0], length(pSeen));
  {$ENDIF}
end;

Begin
  Test(10)  ; OutSeen(10000);
  Test(1000); OutSeen(10);
  Test(MAXNUM); OutSeen(28);
  setlength(PosBefore,0);
end.
