{$IFDEF FPC}
  {$MODE DELPHI} {$Optimization On}
{$ELSE}
  {$APPTAYPE CONSOLE}
{$ENDIF}
{$DEFINE USE_GMP}
uses
  {$IFDEF USE_GMP}
  gmp,
  {$ENDIF}
  sysutils; //format
const
  MAX_LIMIT = 2*1000*1000;
  UpperLimit = MAX_LIMIT+1000;// so to find a prime beyond MAX_LIMIT
  MAX_UINT64 = 46;// unused.Limit to get an Uint64 output
type
  tFactors = array of Uint32;
  tprimelist = array of byte;
var
  primeDeltalist : tPrimelist;
  factors,
  saveFactors:tFactors;
  saveFactorsIdx,
  maxFactorsIdx : Uint32;
procedure Init_Primes;
var
  pPrime : pByte;
  p,i,delta,cnt: NativeUInt;
begin
  setlength(primeDeltalist,UpperLimit+3*8+1);
  pPrime := @primeDeltalist[0];
  //delete multiples of 2,3
  i := 0;
  repeat
    //take care of endianess //0706050403020100
    pUint64(@pPrime[i+0])^ := $0100010000000100;
    pUint64(@pPrime[i+8])^ := $0000010001000000;
    pUint64(@pPrime[i+16])^:= $0100000001000100;
    inc(i,24);
  until i>UpperLimit;
  cnt := 2;// 2,3
  p := 5;
  delta := 1;//5-3
  repeat
    if pPrime[p] <> 0 then
    begin
      i := p*p;
      if i > UpperLimit then
        break;
      inc(cnt);
      pPrime[p-2*delta] := delta;
      delta := 0;
      repeat
        pPrime[i] := 0;
        inc(i,2*p);
      until i>UpperLimit;
    end;
    inc(p,2);
    inc(delta);
  until p*p>UpperLimit;
  setlength(saveFactors,cnt);
  //convert to delta
  repeat
    if pPrime[p]<> 0 then
    begin
      pPrime[p-2*delta] := delta;
      inc(cnt);
      delta := 0;
    end;
    inc(p,2);
    inc(delta);
  until p > UpperLimit;
  setlength(factors,cnt);
  factors[0] := 2;
  factors[1] := 3;
  i := 2;
  p := 5;
  repeat
    factors[i] := p;
    p += 2*pPrime[p];
    i += 1;
  until i >= cnt;
  setlength(primeDeltalist,0);
//  writeln(length(savefactors)); writeln(length(factors));
end;

{$IFDEF USE_GMP}
procedure ConvertToMPZ(const factors:tFactors;dgtCnt:UInt32);
const
  c19Digits = QWord(10*1000000)*1000000*1000000;
var
  mp,mpdiv : mpz_t;
  s : AnsiString;
  rest,last : Uint64;
  f : Uint32;
  i :int32;
begin
  //Init and allocate space
  mpz_init_set_ui(mp,0);
  mpz_init(mpdiv);
  mpz_ui_pow_ui(mpdiv,10,dgtCnt);
  mpz_add(mp,mp,mpdiv);
  mpz_add_ui(mp,mp,1);
  mpz_set_ui(mp,1);

  i := maxFactorsIdx;
  rest := 1;
  repeat
    last := rest;
    f := factors[i];
    rest *= f;
    if rest div f <> last then
    begin
      mpz_mul_ui(mp,mp,last);
      rest := f;
    end;
    dec(i);
  until i < 0;
  mpz_mul_ui(mp,mp,rest);

  If dgtcnt>40 then
  begin
    rest := mpz_fdiv_ui(mp,c19Digits);
    s := '..'+Format('%.19u',[rest]);
    mpz_fdiv_q_ui (mpdiv,mpdiv,c19Digits);
    mpz_fdiv_q(mp,mp,mpdiv);
    rest := mpz_get_ui(mp);
    writeln(rest:19,s);
    mpz_clear(mpdiv);
  end
  else
  Begin
    setlength(s,dgtCnt+1000);
    mpz_get_str(@s[1],10,mp);
    writeln(s);
    i := length(s);
    while not(s[i] in['0'..'9']) do
      dec(i);
    setlength(s,i+1);
    writeln(s);
  end;
  mpz_clear(mp);
end;
{$ENDIF}

procedure CheckDigits(const factors:tFactors);
var
  dgtcnt : extended;
  i : integer;
begin
  dgtcnt := 0;
  i := 0;
  repeat
    dgtcnt += ln(factors[i]);
    inc(i);
  until i > maxFactorsIdx;
  dgtcnt := trunc(dgtcnt/ln(10))+1;
  writeln(' has ',maxFactorsIdx+1:10,' factors and ',dgtcnt:10:0,' digits');
  {$IFDEF USE_GMP}
    i := trunc(dgtcnt);
    if i < 1000*1000 then
      ConvertToMPZ(factors,i);
  {$ENDIF}
end;

function ConvertToUint64(const factors:tFactors):Uint64;
var
  i : integer;
begin
  if maxFactorsIdx >15 then
    Exit(0);
  result := 1;
  for i := 0 to maxFactorsIdx do
    result *= factors[i];
end;

function ConvertToStr(const factors:tFactors):Ansistring;
var
  s : Ansistring;
  i : integer;
begin
  result := '';
  for i := 0 to maxFactorsIdx-1 do
  begin
    str(factors[i],s);
    result += s+'*';
  end;
  str(factors[maxFactorsIdx],s);
  result += s;
end;

procedure GetFactorList(var factors:tFactors;max:Uint32);
var
  p,f,lf : Uint32;
BEGIN
  p := 2;
  lf := 0;
  saveFactors[lf] := p;
  while p*p <= max do
  Begin
    saveFactors[lf] := p;
    f := p*p;
    while f*p <= max do
      f*= p;
    factors[lf] := f;
    inc(lf);
    p := factors[lf];
    if p= 0 then HALT;
  end;
  if lf>0 then
    saveFactorsIdx := lf-1;
  repeat
    inc(lf)
  until factors[lf]>Max;
  maxFactorsIdx := lf-1;
end;

procedure Check(var factors:tFactors;max:Uint32);
var
  i: Uint32;
begin
  GetFactorList(factors,max);
  write(max:10,': ');
  if maxFactorsIdx>15 then
    CheckDigits(factors)
  else
    writeln(ConvertToUint64(factors):21,' = ',ConvertToStr(factors));
  for i := 0 to saveFactorsIdx do
    factors[i] := savefactors[i];
end;

var
  max: Uint32;
BEGIN
  Init_Primes;

  max := 2;
  repeat
    check(factors,max);
    max *=10;
  until max > MAX_LIMIT;

  writeln;
  For max := 10 to 20 do // < MAX_UINT64
    check(factors,max);
{$IFDEF WINDOWS}
  READLN;
{$ENDIF}
END.
