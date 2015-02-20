program Niven;
const
  base = 10;
type
  tNum      = longword;{Uint64}
const
   cntbasedigits = trunc(ln(High(tNum))/ln(base))+1;
type
  tSumDigit = record
                sdNumber  : tNum;
                sdDigits  : array[0..cntbasedigits-1] of byte;
                sdSumDig  : byte;
                sdIsNiven : boolean;
              end;

function InitSumDigit( n : tNum):tSumDigit;
var
  sd : tSumDigit;
  qt : tNum;
  i  : integer;
begin
  with sd do
  begin
    sdNumber:= n;
    fillchar(sdDigits,SizeOf(sdDigits),#0);
    sdSumDig :=0;
    sdIsNiven := false;
    i := 0;
    // calculate Digits und sum them up
    while n > 0 do
    begin
      qt := n div base;
      {n mod base}
      sdDigits[i] := n-qt*base;
      inc(sdSumDig,sdDigits[i]);
      n:= qt;
      inc(i);
    end;
    IF sdSumDig  >0 then
      sdIsNiven := (sdNumber MOD sdSumDig = 0);
  end;
  InitSumDigit:=sd;
end;

procedure IncSumDigit(var sd:tSumDigit);
var
   i,d: integer;
begin
  i := 0;
  with sd do
  begin
    inc(sdNumber);
    repeat
      d := sdDigits[i];
      inc(d);
      inc(sdSumDig);
      //base-1 times the repeat is left here
      if d < base then
      begin
        sdDigits[i] := d;
        BREAK;
      end
      else
      begin
        sdDigits[i] := 0;
        dec(sdSumDig,base);
        inc(i);
      end;
    until i > high( sdDigits);
    sdIsNiven := (sdNumber MOD sdSumDig) = 0;
  end;
end;

var
  MySumDig : tSumDigit;
  ln : tNum;
  cnt: integer;
begin
  MySumDig:=InitSumDigit(0);
  cnt := 0;
  repeat
    IncSumDigit(MySumDig);
    IF MySumDig.sdIsNiven then
    begin
      write(MySumDig.sdNumber,'.');
      inc(cnt);
    end;
  until cnt >= 20;
  write('....');
  MySumDig:=InitSumDigit(1000);
  repeat
    IncSumDigit(MySumDig);
  until MySumDig.sdIsNiven;
  writeln(MySumDig.sdNumber,'.');
// searching for big gaps between two niven-numbers
//  MySumDig:=InitSumDigit(18879989100-276);
  MySumDig:=InitSumDigit(1);
  cnt := 0;
  ln:= MySumDig.sdNumber;
  repeat
    IncSumDigit(MySumDig);
    if MySumDig.sdIsNiven then
    begin
      IF cnt < (MySumDig.sdNumber-ln) then
      begin
        cnt :=(MySumDig.sdNumber-ln);
        writeln(ln,' --> ',MySumDig.sdNumber,'  d=',cnt);
      end;
      ln:= MySumDig.sdNumber;
    end;
  until MySumDig.sdNumber= High(tNum);
{
689988915 --> 689989050  d=135
879987906 --> 879988050  d=144
989888823 --> 989888973  d=150
2998895823 --> 2998895976  d=153
~ 24 Cpu-cycles per test i3- 4330 1..2^32-1}
end.
