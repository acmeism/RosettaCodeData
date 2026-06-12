program mindistance;
{$IFDEF FPC} //used fpc 3.2.1
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;

type
  tMinDist = array of Uint32;
  tpMinDist= pUint32;
var
  dgtwidth : NativeUint;
  OneRowElems : tMinDist;

function CalcDigitWidth(n: NativeUint):NativeUint;
begin
  result:= 2;
  while n>= 10 do
  Begin
    inc(result);
    n := n DIV 10;
  end;
end;

procedure OutOneRow(var OneRowElems:tMinDist);
var
  one_digit,one_row :string;
  i : NativeInt;
begin
  one_row:= '';
  For i := low(OneRowElems) to High(OneRowElems) do
  begin
    str(OneRowElems[i]:dgtwidth,one_digit);
    one_row += one_digit;
  end;
  writeln(one_row);
end;

procedure OutSquareDist(MaxCoor : NativeUInt);
var
  pRes : tpMinDist;
  min_dist,row : NativeInt;
begin
  //iniated with 0
  setlength(OneRowElems,MaxCoor);
  MaxCoor -= 1;//= High(OneRowElems);
  pRes := @OneRowElems[0];

  row := MaxCoor;
  repeat
    min_dist := MaxCoor-row;
    if min_dist > row  then
      min_dist := row;
    //fill the inner rest with min_dist
    FillDWord(pRes[min_dist],(MaxCoor-2*min_dist+1),min_dist);

    OutOneRow(OneRowElems);

    dec(row);
  until row < 0;
  writeln;
  setlength(OneRowElems,0);
end;

procedure Test(MaxCoor:NativeInt);
begin
  if MaxCoor<= 0 then
    EXIT;
  write('Minimum number of cells after, before, above and below ');
  writeln(MaxCoor,' x ',MaxCoor,' square:');
  dgtwidth := CalcDigitWidth(NativeUint(MaxCoor) DIV 2);
  OutSquareDist(MaxCoor);
end;

Begin
//  Test(200*1000);// without output TIO.RUN Real time: 4.152 s CPU share: 97.70 %
  Test(23);
  Test(10);
  Test(9);
  Test(1);
end.
