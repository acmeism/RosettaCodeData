program VileOrDopey;
{$MODE DELPHI}{$OPTIMIZATION ON,ALL}
uses
  sysutils;
type
  tmax2Pow = 1..31;

var
  // upper limit must be even > 1
  IsVile : array of boolean;

procedure InitIsVile(max2Pow:tmax2Pow);
var
  pIsVile : pboolean;
  i,j,lmt : Uint32;
begin
  lmt := 1 shl max2Pow;
  setlength(isVile,lmt+1);
  pIsVile := @IsVile[0];
  i := 1;
  j := 0;
  while i< Lmt do
  begin
    // odd number
    pIsVile[i] := true;
    inc(j);
    inc(i);
    //even number j := i DIV 2;
    if Not(pIsVile[j]) then
      pIsVile[i] := true;
    //alternative pIsVile[i] := Not(pIsVile[j]) then
    inc(i);
  end;
end;

function CountIsVile(lowLmt,lmt:UInt32):UInt32;
var
  pIsVile : pboolean;
begin
  pIsVile := @IsVile[0];
  result := 0;
  for lowlmt := lowlmt to Lmt do
    inc(result,Ord(pIsVile[lowlmt]));
end;

procedure OutfirstN(n: Integer;chkIsVile:Boolean);
const
  name : array[false..true] of string=(' dobey ','  vile ');
var
  pIsVile : pboolean;
  i: Integer;
begin
  pIsVile := @IsVile[0];
  write('First ',n,name[chkIsVile],'numbers :');
  i := 1;
  while n > 0 do
  begin
    if pIsVile[i] = chkIsVile then
    Begin
      write(i:3);
      dec(n);
    end;
    inc(i);
  end;
  writeln;
end;

var
  i,cnt,lowLmt,lmt : UInt32;
  max2Pow:tmax2Pow;

BEGIN
  max2Pow := 31;
  InitIsVile(max2Pow);

//  First 25 vile  numbers
  OutfirstN(25,true);
//  First 25 dobey  numbers
  OutfirstN(25,false);

  writeln('power   2^power  vile count  dopey count');
  lowLmt := 1;
  cnt := 0;
  For i := 1 to max2Pow do
  begin
    lmt := UInt32(1) shl i;
    cnt += CountIsVile(lowLmt,lmt);
    lowLmt := lmt+1;
    writeln(i:4,lmt:11,cnt:12,lmt-cnt:13);
  end;
  setlength(isVile,0);
END.
