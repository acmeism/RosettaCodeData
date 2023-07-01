program TetraPrimes;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}
   {$CodeAlign proc=1,loop=1} // for Ryzen 5xxx
{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,primsieve;
const
  cLimit =1000*1000*1000;

  MinTriple = 2*3*5;
  MInQuad =  MinTriple*7;
  cBits2pow = 6; // 2^ 6 = 64-Bit
  cMask = 1 shl cBits2pow-1;

type
  tIdx = 0..1 shl cBits2pow-1;
  tSetBits = set of tIdx;
  tMyResult = record
               mr_Limit,
               mr_cnt,
               mr_cnt7,
               mr_min,
               mr_median,
               mr_gapsum,
               mr_max  : Uint32;
               mr_dir : boolean;
             end;
var
  MarkTetraPrimes : array of tSetBits;
  MyPrimes : array of Uint32;
  GapCnt: array[0..14660 shr 2] of Uint32;
  SmallTetraPrimes : array[0..49] of Uint32;
  MyResult : tMyResult;
  MaxPrime,HighMyPrimes,count : Uint32;

procedure GenerateTetraPrimes(Factor:NativeUint;MinIdx,CountOfFactors:Uint32);
var
  fp,
  p : NativeUint;
begin
  dec(CountOfFactors);
  If (CountOfFactors = 0) then
  begin
    For MinIdx := MinIdx to HighMyPrimes do
    begin
      fp := Factor * MyPrimes[MinIdx];
      if fp > cLimit then
        BREAK;
      inc(count);
      include(MarkTetraPrimes[fp SHR cBits2pow],fp AND cMask);
    end;
  end
  else
    For MinIdx := MinIdx to HighMyPrimes-CountOfFactors do
    begin
      p := MyPrimes[MinIdx];
      fp :=p*Factor;
      case CountOfFactors of
        2 : p *= p;
        3 : p *= p*p;
      else
      end;
      if fp*p < cLimit then
        GenerateTetraPrimes(fp,MinIdx+1,CountOfFactors);
    end;
end;

procedure GetTetraPrimes(Limit:Uint32);
var
  l,
  p,i : Uint32;
Begin
  setlength(MarkTetraPrimes, Limit shr cBits2pow);
  //estimate count of primes
  if limit < 10 then
    setlength(MyPrimes,4)
  else
    setlength(MyPrimes,round(Limit/(ln(limit)-1.5)));

  InitPrime;
  L :=Limit DIV  MinTriple;
  i := 0;
  repeat
    p := NextPrime;
    MyPrimes[i] := p;
    inc(i);
  until p > l;
  HighMyPrimes := i;
  repeat
    p := NextPrime;
    MyPrimes[i] := p;
    inc(i);
  until p > limit;
  setlength(MyPrimes,i-1);
  MaxPrime := MyPrimes[HighMyPrimes];

  GenerateTetraPrimes(1,0,4);
end;

function TwoInRow(p : NativeUint;dirUp:Boolean = false):boolean;
var
  delta : NativeUint;
begin
  if (p < minquad) then
    EXIT(false);
  delta := ORD(DirUp)*2-1;//= +1,-1
  if  2*delta+p >cLimit then
    EXIT(false);
  p += delta;
  if (p AND cMask) in MarkTetraPrimes[p SHR cBits2pow] then
  begin
    p += delta;
    if (p AND cMask) in MarkTetraPrimes[p SHR cBits2pow] then
      EXIT(true);
  end;
  EXIT(false);
end;

procedure CheckLimitDirUp(var Res:tMyResult;Limit:NativeUint;dirUp:boolean);
var
  p,Last,GapSum,cnt,cnt7 : UInt32;
  i,d : Int32;
Begin
  FillChar(GapCnt,SizeOf(GapCnt),#0);
  Last := 0;
  cnt := 0;
  cnt7 := 0;
  GapSum := 0;
  if dirUp then
    d := 1
  else
    d := -1;

  for i := 0 to High(myPrimes) do
  begin
    p := MyPrimes[i];
    If p > Limit then
      BREAK;
    if TwoInRow(p,dirUp) then
    Begin
      If Last <> 0 then
      Begin
        Last := (p-Last) shr 2;
        GapSum+=Last;
        Inc(GapCnt[Last]);
      end;
      Last := p;
      if limit <= 100*1000 then
        SmallTetraPrimes[cnt] := p;

      inc(cnt);
      p += d;
      if p MOD 7 = 0 then
        inc(cnt7)
      else
        if (p+d) MOD 7 = 0 then
          inc(cnt7);
    end;
  end;
  with res do
  begin
    mr_limit:= Limit;
    mr_cnt := cnt;
    mr_cnt7 := cnt7;
    mr_dir := dirUp;
  end;
  If cnt > 1 then
  Begin
    For i := 0 to High(GapCnt) do
      IF GapCnt[i] <> 0 then
      begin
        res.mr_min := i shl 2;
        BREAK;
      end;
    For i := High(GapCnt) downto 0 do
      IF GapCnt[i] <> 0 then
      begin
        res.mr_max := i shl 2;
        BREAK;
      end;
    //median;
    Limit := cnt DIV 2;
    p := 0;
    For i := 0 to res.mr_max do
    Begin
      inc(p,GapCnt[i]);
      IF p >= Limit then
      begin
        res.mr_median := i*4;
        BREAK;
      end;
    end;

    res.mr_GapSum := GapSum*4;
  end;
  if limit <= 100*1000 then
    writeln;
end;

procedure Out_Res(const res:tMyResult);
const
  Direction : array[Boolean]of string =(' preceded ',' followed ');
var
  i : integer;
begin
  with res do
  Begin
    writeln('Primes below ',mr_limit,Direction[mr_dir],' by a tetraprime pair:');
    if mr_cnt < 50 then
    begin
      For i := 0 to mr_cnt-1 do
      Begin
        write(SmallTetraPrimes[i]:7);
        if (i+1) MOD 10 = 0 then
          writeln;
      end;
      writeln;
    end;
    writeln(#9,'Found ',mr_cnt,' such primes of which ',mr_cnt7,' have 7 as a factor of one of the pair');
    writeln(#9#9'GapCnt between the primes: min: ',mr_min,
            ', average: ',mr_GapSum/(mr_cnt-1):0:1,
            ', median: ',mr_median,
            ', max: ',mr_max);
  end;
end;

procedure CheckLimit(Limit:NativeUint);
const
  preceded = false;
  followed = true;

var
  myResult :TMyResult;
begin
  CheckLimitDirUp(myResult,Limit,preceded);
  Out_Res(myResult);
  CheckLimitDirUp(myResult,Limit,followed);
  Out_Res(myResult);
  writeln;
end;

var
  i : Uint32;
Begin
  GetTetraPrimes(cLimit);
  GenerateTetraPrimes(1,0,4);
  i := 100000;
  repeat
    CheckLimit(i);
    i *= 10
  until i >= cLimit;
  CheckLimit(cLimit);
end.
