program Niven;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

const
  base = 10;

type
  tNum = longword; {Uint64}
{$IFDEF FPC}

const
  cntbasedigits = trunc(ln(High(tNum)) / ln(base)) + 1;
{$ELSE}

var
  cntbasedigits: Integer = 0;
{$ENDIF}

type
  tSumDigit = record
    sdNumber: tNum;
{$IFDEF FPC}
    sdDigits: array[0..cntbasedigits - 1] of byte;
{$ELSE}
    sdDigits: TArray<Byte>;
{$ENDIF}
    sdSumDig: byte;
    sdIsNiven: boolean;
  end;

function InitSumDigit(n: tNum): tSumDigit;
var
  sd: tSumDigit;
  qt: tNum;
  i: integer;
begin
  with sd do
  begin
    sdNumber := n;
{$IFDEF FPC}
    fillchar(sdDigits, SizeOf(sdDigits), #0);
{$ELSE}
    SetLength(sdDigits,cntbasedigits);
    fillchar(sdDigits[0], SizeOf(sdDigits), #0);
{$ENDIF}
    sdSumDig := 0;
    sdIsNiven := false;
    i := 0;
    // calculate Digits und sum them up
    while n > 0 do
    begin
      qt := n div base;
      {n mod base}
      sdDigits[i] := n - qt * base;
      inc(sdSumDig, sdDigits[i]);
      n := qt;
      inc(i);
    end;
    if sdSumDig > 0 then
      sdIsNiven := (sdNumber mod sdSumDig = 0);
  end;
  InitSumDigit := sd;
end;

procedure IncSumDigit(var sd: tSumDigit);
var
  i, d: integer;
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
        dec(sdSumDig, base);
        inc(i);
      end;
    until i > high(sdDigits);
    sdIsNiven := (sdNumber mod sdSumDig) = 0;
  end;
end;

var
  MySumDig: tSumDigit;
  lnn: tNum;
  cnt: integer;

begin
{$IFNDEF FPC}
  cntbasedigits := trunc(ln(High(tNum)) / ln(base)) + 1;
{$ENDIF}

  MySumDig := InitSumDigit(0);
  cnt := 0;
  repeat
    IncSumDigit(MySumDig);
    if MySumDig.sdIsNiven then
    begin
      write(MySumDig.sdNumber, '.');
      inc(cnt);
    end;
  until cnt >= 20;
  write('....');
  MySumDig := InitSumDigit(1000);
  repeat
    IncSumDigit(MySumDig);
  until MySumDig.sdIsNiven;
  writeln(MySumDig.sdNumber, '.');
// searching for big gaps between two niven-numbers
//  MySumDig:=InitSumDigit(18879989100-276);
  MySumDig := InitSumDigit(1);
  cnt := 0;
  lnn := MySumDig.sdNumber;
  repeat
    IncSumDigit(MySumDig);
    if MySumDig.sdIsNiven then
    begin
      if cnt < (MySumDig.sdNumber - lnn) then
      begin
        cnt := (MySumDig.sdNumber - lnn);
        writeln(lnn, ' --> ', MySumDig.sdNumber, '  d=', cnt);
      end;
      lnn := MySumDig.sdNumber;
    end;
  until MySumDig.sdNumber = High(tNum);
{
689988915 --> 689989050  d=135
879987906 --> 879988050  d=144
989888823 --> 989888973  d=150
2998895823 --> 2998895976  d=153
~ 24 Cpu-cycles per test i3- 4330 1..2^32-1}
{$IFNDEF LINUX}readln;{$ENDIF}
end.
