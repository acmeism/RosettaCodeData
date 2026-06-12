program Dec_Hex_same_UsedDigits;
//Generating hexnumbers only containing decimal digits
//Than check if converted to decimal are using the same set of digits
//for 1e9 only 40e6 tests are needed.
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
  UpperLimit =  100*1000;//1000*1000*1000;//
type
  tUsedDigits = array[0..15] of byte;
var
  FormCnt: Int32;
  UsedDigits : tUsedDigits;

procedure Out_(n,h:Uint32);
Begin
  write(n:11,' = 0x',h);
  inc(FormCnt);
  If FormCnt >= 4 then
  Begin
    FormCnt := 0;
    writeln;
  end
  else
    if h <> 0 then
      write('':7-trunc(ln(h)/ln(10)))
    else
     write('':7);
end;

function CnvHexNumToDec(n:Uint32):UInt32;
//convert n treating their decimal digits are a hex number
//marking used Digits
var
  pD : pUint64;
  q,r,pot16 : UInt32;
begin
//clear UsedDigits
//For q := Low(UsedDigits) to High(UsedDigits) do  UsedDigits[q] := 0;
//much faster
  pD := @UsedDigits;pD[0]:= 0;pD[1]:= 0;

  result := 0;
  pot16 := 0;
  repeat
    q := n Div 10;
    r := n - 10* q;//n mod 10
    //set by hexdigit
    UsedDigits[r] := 2;
    result := result+ r shl pot16;
    inc(pot16,4);
    n := q;
  until n = 0;
end;

var
  HexWithDecDigits,HexNumInDec:Uint32;
  i,q,r,count : Uint32;
Begin
  FormCnt := 0;
  count := 0;
  HexWithDecDigits := 0;
  repeat
    HexNumInDec := CnvHexNumToDec(HexWithDecDigits);
    if HexNumInDec > UpperLimit then
      break;
    //check UsedDigits
    i := HexNumInDec;
    repeat
      q := i Div 10;
      r := i - 10* q;
      //if unused digit then break
      if UsedDigits[r] = 0 then
        BREAK;
      //set by decimal digit
      UsedDigits[r] := 1;
      i := q;
    until i = 0;
    if i = 0 then
    Begin
      repeat
        //was marked only by hex
        if UsedDigits[i]>1 then
          break;
        inc(i);
      until i > 9;
      if i > 9 then
      Begin
        if HexNumInDec< 100*1000 then
          Out_(HexNumInDec,HexWithDecDigits);
        inc(count);
      end;
    end;
    inc(HexWithDecDigits);
  until false;
  writeln;
  writeln('count : ',count);
  writeln('Max tested hex number 0x',HexWithDecDigits,' = ',HexNumInDec);
END.
