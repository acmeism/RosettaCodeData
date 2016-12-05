program lucid;
{$IFDEF FPC}
  {$MODE objFPC} // useful for x64
{$ENDIF}

const
  //66164 -> last < 1000*1000;
  maxLudicCnt = 2005;//must be > 1
type

  tDelta = record
             dNum,
             dCnt : LongInt;
           end;

  tpDelta = ^tDelta;
  tLudicList = array of tDelta;

  tArrdelta =array[0..0] of tDelta;
  tpLl = ^tArrdelta;

function isLudic(plL:tpLl;maxIdx:nativeInt):boolean;
var
  i,
  cn : NativeInt;
Begin
  //check if n is 'hit' by a prior ludic number
  For i := 1 to maxIdx do
    with plL^[i] do
    Begin
      //Mask read modify write reread
      //dec(dCnt);IF dCnt= 0
      cn := dCnt;
      IF cn = 1 then
      Begin
        dcnt := dNum;
        isLudic := false;
        EXIT;
       end;
      dcnt := cn-1;
    end;
  isLudic := true;
end;

procedure CreateLudicList(var Ll:tLudicList);
var
  plL : tpLl;
  n,LudicCnt : NativeUint;
begin
  // special case 1
  n := 1;
  Ll[0].dNum := 1;

  plL := @Ll[0];
  LudicCnt := 0;
  repeat
    inc(n);
    If isLudic(plL,LudicCnt ) then
    Begin
      inc(LudicCnt);
      with plL^[LudicCnt] do
      Begin
        dNum := n;
        dCnt := n;
      end;
      IF (LudicCnt >= High(LL)) then
        BREAK;
    end;
  until false;
end;

procedure  firstN(var Ll:tLudicList;cnt: NativeUint);
var
  i : NativeInt;
Begin
  writeln('First ',cnt,' ludic numbers:');
  For i := 0 to cnt-2 do
    write(Ll[i].dNum,',');
  writeln(Ll[cnt-1].dNum);
end;

procedure triples(var Ll:tLudicList;max: NativeUint);
var
  i,
  chk : NativeUint;
Begin
  // special case 1,3,7
  writeln('Ludic triples below ',max);
  write('(',ll[0].dNum,',',ll[2].dNum,',',ll[4].dNum,') ');

  For i := 1 to High(Ll) do
  Begin
    chk := ll[i].dNum;
    If chk> max then
      break;
    If (ll[i+2].dNum = chk+6) AND (ll[i+1].dNum = chk+2) then
      write('(',ll[i].dNum,',',ll[i+1].dNum,',',ll[i+2].dNum,') ');
  end;
  writeln;
  writeln;
end;

procedure LastLucid(var Ll:tLudicList;start,cnt: NativeUint);
var
  limit,i : NativeUint;
Begin
  dec(start);
  limit := high(Ll);
  IF cnt >= limit then
    cnt := limit;
  if start+cnt >limit then
    start := limit-cnt;
  writeln(Start+1,'.th to ',Start+cnt+1,'.th ludic number');
  For i := 0 to cnt-1 do
    write(Ll[i+start].dNum,',');
  writeln(Ll[start+cnt].dNum);
  writeln;
end;

function CountLudic(var Ll:tLudicList;Limit: NativeUint):NativeUint;
var
  i,res : NativeUint;
Begin
  res := 0;
  For i := 0 to High(Ll) do begin
    IF Ll[i].dnum <= Limit then
      inc(res)
    else
      BREAK;
  CountLudic:= res;
end;

end;
var
  LudicList : tLudicList;
BEGIN
  setlength(LudicList,maxLudicCnt);
  CreateLudicList(LudicList);
  firstN(LudicList,25);
  writeln('There are ',CountLudic(LudicList,1000),' ludic numbers below 1000');
  LastLucid(LudicList,2000,5);
  LastLucid(LudicList,maxLudicCnt,5);
  triples(LudicList,250);//all-> (LudicList,LudicList[High(LudicList)].dNum);
END.
