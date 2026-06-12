{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS} {$APPTYPE CONSOLE}{$ENDIF}
uses
  primsieve;
  function SumOfDecDigits(n:UInt64): Uint32; forward;
const
  DgtMod = 10000;
var
{$ALIGN 32}
  SumDigits : array[0..DgtMod-1] of byte;
procedure Init;
var
  i,
  a,b,c,d : NativeUint;
Begin
  i := DgtMod-1;
  For a := 9 downto 0 do
    For b := 9 downto 0 do
      For c := 9 downto 0 do
        For d := 9 downto 0 do
        Begin
          SumDigits[i] := a+b+c+d;
          dec(i);
        end;
end;

procedure OutSpecial(idxH,idxP,p,CntDecDgt:Uint64);
Begin
  write('(',idxH:9,idxP:11,p:13);
  writeln(' Digitsum :',SumOfDecDigits(p):3,' < ',CntDecDgt:3,' Count of digits )');
end;

procedure OutHonaker(idxH,idxP,p:Uint64);
begin
  writeln('(',idxH:9,idxP:11,p:13,')');
end;

function SumOfDecDigits(n:UInt64): Uint32;
var
  tmp: Uint64;
  digit: Uint32;
Begin
  result := 0;
  repeat
    tmp := n div DgtMod;
    digit := n-tmp*DgtMod;
    n := tmp;
    result +=SumDigits[digit];
  until n=0;
end;

var
  idxP,p,DecDgtLimit : Uint64;
  idxH,lmt,SumDgtPrime,CntDecDgt : UInt32;
Begin
  init;

  idxP := 0;
  idxH := 0;
  CntDecDgt := 1;
  DecDgtLimit := 10;
  Writeln(' First 50 Honaker primes ');
  repeat
    p := NextPrime;
    inc(idxP);
    SumDgtPrime := SumOfDecDigits(idxP);
    If SumOfDecDigits(idxP) = SumOfDecDigits(p) then
    begin
      inc(IdxH);
      if idxH<= 50 then
      Begin
        write('(',idxH:3,idxP:4,p:5,')');
        if Idxh mod 5=0 then writeln;
      end;
    end;
  until idxH= 50;

  lmt := 100;
  CntDecDgt := 1;
  DecDgtLimit := 10;
  while DecDgtLimit < p do
  Begin
    CntDecDgt += 1;
    DecDgtLimit *= 10;
  end;
  Writeln;
  Writeln('      n.th   PrimeIdx      Prime');
  repeat
    p := NextPrime;
    inc(idxP);
    IF p > DecDgtLimit then
    Begin
      CntDecDgt += 1;
      DecDgtLimit *= 10;
    end;
    SumDgtPrime := SumOfDecDigits(idxP);
    If SumOfDecDigits(idxP) = SumOfDecDigits(p) then
    begin
      inc(IdxH);
      while p > DecDgtLimit do
      Begin
        CntDecDgt += 1;
        DecDgtLimit *= 10;
      end;
      if SumDgtPrime < CntDecDgt then
        OutSpecial(idxH,idxP,p,CntDecDgt);
      if idxH = lmt then
      Begin
        OutHonaker(idxH,idxP,p);
        lmt *= 10;
      end;
    end;
  until lmt> 100*1000*1000;
end.
