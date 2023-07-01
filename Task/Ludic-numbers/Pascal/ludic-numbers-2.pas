program ludic;
{$IFDEF FPC}{$MODE DELPHI}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
const
  MAXNUM =21511;// > 1
  //1561333;-> 100000 ludic numbers
  //1561243,1561291,1561301,1561307,1561313,1561333
type
  tarrLudic = array of byte;
  tLudics = array of LongWord;

var
  Ludiclst : tarrLudic;

procedure Firsttwentyfive;
var
  i,actLudic : NativeInt;
Begin
  writeln('First 25 ludic numbers');
  actLudic:= 1;
  For i := 1 to 25 do
  Begin
    write(actLudic:3,',');
    inc(actLudic,Ludiclst[actLudic]);
    IF i MOD 5 = 0 then
      writeln(#8#32);
  end;
  writeln;
end;

procedure CountBelowOneThousand;
var
  cnt,actLudic : NativeInt;
Begin
  write('Count of ludic numbers below 1000 = ');
  actLudic:= 1;
  cnt := 1;
  while actLudic <= 1000 do
  Begin
    inc(actLudic,Ludiclst[actLudic]);
    inc(cnt);
  end;
  dec(cnt);
  writeln(cnt);writeln;
end;

procedure Show2000til2005;
var
  cnt,actLudic : NativeInt;
Begin
  writeln('ludic number #2000 to #2005');
  actLudic:= 1;
  cnt := 1;
  while cnt < 2000 do
  Begin
    inc(actLudic,Ludiclst[actLudic]);
    inc(cnt);
  end;
  while cnt < 2005 do
  Begin
    write(actLudic,',');
    inc(actLudic,Ludiclst[actLudic]);
    inc(cnt);
  end;
  writeln(actLudic);writeln;
end;

procedure ShowTriplets;
var
  actLudic,lastDelta : NativeInt;
Begin
  writeln('ludic numbers triplets below 250');
  actLudic:= 1;
  while actLudic < 250-5 do
  Begin
    IF (Ludiclst[actLudic]   <> 0) AND
       (Ludiclst[actLudic+2] <> 0) AND
       (Ludiclst[actLudic+6] <> 0) then
      writeln('{',actLudic,'|',actLudic+2,'|',actLudic+6,'} ');
    inc(actLudic);
  end;
  writeln;
end;

procedure CheckMaxdist;
var
  actLudic,Delta,MaxDelta : NativeInt;
Begin
  MaxDelta := 0;
  actLudic:= 1;
  repeat
    delta := Ludiclst[actLudic];
    inc(actLudic,delta);
    IF MAxDelta<delta then
       MAxDelta:= delta;
  until actLudic>= MAXNUM;
  writeln('MaxDist ',MAxDelta);writeln;
end;

function GetLudics:tLudics;
//Array of byte containing the distance to next ludic number
//eliminated numbers are set to 0
var
  i,actLudic,actcnt,delta,actPos,lastPos,ludicCnt: NativeInt;
Begin
  setlength(Ludiclst,MAXNUM+1);
  For i := MAXNUM downto 0 do
    Ludiclst[i]:= 1;
  actLudic := 1;
  ludicCnt := 1;

  repeat
    inc(actLudic,Ludiclst[actLudic]);
    IF actLudic> MAXNUM then
      BREAK;
    inc(ludicCnt);
    actPos := actLudic;
    actcnt := 0;
    // Only if there are enough ludics left
    IF MaxNum-ludicCnt-actPos > actPos then
    Begin
    //eliminate every element in actLudic-distance
      //delta so i can set Ludiclst[actpos] to zero
      delta := Ludiclst[actpos];
      repeat
        lastPos := actPos;
        inc(actpos,delta);
        if actPos>=MAXNUM then
          BREAK;
        delta := Ludiclst[actpos];
        inc(actcnt);
        IF actcnt= actLudic then
        Begin
          inc(Ludiclst[LastPos],delta);
          //mark as not ludic
          Ludiclst[actpos] := 0;
          actcnt := 0;
        end;
      until false;
    end;
  until false;
  writeln(ludicCnt,' ludic numbers upto ',MAXNUM,#13#10);
end;

BEGIN
  GetLudics;
  CheckMaxdist;
  Firsttwentyfive;CountBelowOneThousand;Show2000til2005;ShowTriplets ;
  setlength(Ludiclst,0)
END.
