program Sisyphus;
{$IFDEF FPC}
  {$MODE DELPHI}{$Coperators ON}{$Optimization ON}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,
  primsieve;// https://rosettacode.org/wiki/Extensible_prime_generator#Pascal

function CommatizeUint64(num:Uint64):AnsiString;
var
   fromIdx,toIdx :Int32;
Begin
  str(num,result);
  fromIdx := length(result);
  toIdx := fromIdx-1;
  if toIdx < 3 then
    exit;

  toIdx := 4*(toIdx DIV 3)+toIdx MOD 3 +1 ;
  setlength(result,toIdx);
  repeat
    result[toIdx]   := result[FromIdx];
    result[toIdx-1] := result[FromIdx-1];
    result[toIdx-2] := result[FromIdx-2];
    result[toIdx-3] := ',';
    dec(toIdx,4);
    dec(FromIdx,3);
  until FromIdx<=3;
end;

procedure OutOne(n,count: Uint64);
Begin
  write(n:5);
  If count mod 10 = 0 then
    writeln;
end;

procedure OutRes(n,count,p:Uint64);
Begin
  writeln(CommatizeUint64(n):15, ' found after ',CommatizeUint64(count):12,' iterations: Max prime ',CommatizeUint64(p):12);
end;

procedure CheckSmall;
var
  CntOccurence : array[0..255] of byte;
  n,count,p,limit : Uint64;
begin
  InitPrime;
  writeln('The first 100 members of the Sisyphus sequence');
  fillchar(CntOccurence,SizeOf(CntOccurence),#0);
  n := 1;
  count := 1;
  Limit := 1000;
  CntOccurence[n] := 1;

  repeat
    if count <= 100 then
    Begin
      OutOne(n,count);
      if count = 100 then
        writeln;
   end;

   if n AND 1 = 0 then
     n := n shr 1
   else
   begin
     p := nextprime;
     n += p;
   end;
   count+= 1;
   iF n < 255 then
     inc(CntOccurence[n]);

   if (count = Limit) then
   Begin
     OutRes(n,count,p);
     Limit *= 10;
   end;
  until Limit > 100*1000*1000;

  writeln(#10,'Not found numbers below 250 after ',CommatizeUint64(count),' iterations');
  p := 0;// maximum
  For n := 1 to 250 do
  begin
    if CntOccurence[n] = 0 then
      write(n:4);
    if p < CntOccurence[n] then
      p := CntOccurence[n];
  end;
  Writeln;

  writeln(#10,'Mostly found numbers below 250 after ',CommatizeUint64(count),' iterations');
  For n := 1 to 250 do
    if CntOccurence[n] = p then
      write(n:4);
  Writeln(' found ',p,' times');
end;

procedure Check;
var
  n,count,target,p : Uint64;
begin
  InitPrime;
  n := 1;
  count := 1;
  Target := 36;
  repeat
    if n AND 1 = 0 then
      n := n shr 1
    else
    begin
      p := nextprime;
      n += p;
    end;
    count+= 1;
    if (n = target) then
    Begin
      OutRes(n,count,p);
      BREAK;
    end;
  until false;
end;

BEGIN
  CheckSmall;
  writeln;
  CHECK;
end.
